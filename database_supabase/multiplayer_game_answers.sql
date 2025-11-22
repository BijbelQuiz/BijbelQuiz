-- Multiplayer game answers table
CREATE TABLE IF NOT EXISTS multiplayer_game_answers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    game_session_id UUID NOT NULL REFERENCES multiplayer_game_sessions(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    question_index INTEGER NOT NULL,
    answer TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    answer_time_seconds INTEGER,
    points_earned INTEGER NOT NULL DEFAULT 0,
    answered_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(game_session_id, player_id, question_index)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_multiplayer_game_answers_game_session_id ON multiplayer_game_answers(game_session_id);
CREATE INDEX IF NOT EXISTS idx_multiplayer_game_answers_player_id ON multiplayer_game_answers(player_id);
CREATE INDEX IF NOT EXISTS idx_multiplayer_game_answers_question_index ON multiplayer_game_answers(question_index);

-- RLS policies
ALTER TABLE multiplayer_game_answers ENABLE ROW LEVEL SECURITY;

-- Allow players to read answers in their game session
CREATE POLICY "Players can read answers in their game session" ON multiplayer_game_answers
    FOR SELECT USING (
        game_session_id IN (
            SELECT id FROM multiplayer_game_sessions
            WHERE organizer_id = auth.uid()
        ) OR
        player_id = auth.uid()
    );

-- Allow players to insert their own answers
CREATE POLICY "Players can insert their own answers" ON multiplayer_game_answers
    FOR INSERT WITH CHECK (player_id = auth.uid());

-- Allow organizer to read all answers in their game session
CREATE POLICY "Organizer can read all answers in their game session" ON multiplayer_game_answers
    FOR SELECT USING (
        game_session_id IN (
            SELECT id FROM multiplayer_game_sessions
            WHERE organizer_id = auth.uid()
        )
    );

-- Function to validate answer and calculate points server-side with enhanced timing protection
CREATE OR REPLACE FUNCTION validate_and_score_answer(
    p_game_session_id UUID,
    p_player_id UUID,
    p_question_index INTEGER,
    p_answer TEXT,
    p_answer_time_seconds INTEGER
) RETURNS TABLE(
    is_correct BOOLEAN,
    points_earned INTEGER,
    validation_error TEXT
) AS $$
DECLARE
    v_question_data JSONB;
    v_correct_answer TEXT;
    v_question_time_limit INTEGER := 20;
    v_question_start_time TIMESTAMPTZ;
    v_current_time TIMESTAMPTZ := NOW();
    v_time_elapsed_seconds INTEGER;
    v_client_reported_time INTEGER := p_answer_time_seconds;
    v_is_correct BOOLEAN := FALSE;
    v_points INTEGER := 0;
    v_error TEXT := NULL;
    v_existing_answer_count INTEGER;
    v_time_discrepancy INTEGER;
    v_max_allowed_discrepancy INTEGER := 3; -- Maximum allowed time difference in seconds
BEGIN
    -- Check if answer already exists for this question
    SELECT COUNT(*) INTO v_existing_answer_count
    FROM multiplayer_game_answers
    WHERE game_session_id = p_game_session_id
      AND player_id = p_player_id
      AND question_index = p_question_index;

    IF v_existing_answer_count > 0 THEN
        RETURN QUERY SELECT FALSE, 0, 'Answer already submitted for this question'::TEXT;
        RETURN;
    END IF;

    -- Get question start time and validate timing
    SELECT current_question_start_time INTO v_question_start_time
    FROM multiplayer_game_sessions
    WHERE id = p_game_session_id;

    IF v_question_start_time IS NULL THEN
        RETURN QUERY SELECT FALSE, 0, 'Question not active'::TEXT;
        RETURN;
    END IF;

    -- Calculate actual time elapsed server-side
    v_time_elapsed_seconds := EXTRACT(EPOCH FROM (v_current_time - v_question_start_time))::INTEGER;

    -- Validate timing: answer must be submitted within reasonable time bounds
    -- Allow some network latency (add 5 seconds grace period)
    IF v_time_elapsed_seconds < 0 THEN
        RETURN QUERY SELECT FALSE, 0, 'Answer submitted before question started'::TEXT;
        RETURN;
    END IF;

    IF v_time_elapsed_seconds > (v_question_time_limit + 5) THEN
        RETURN QUERY SELECT FALSE, 0, 'Answer submitted too late'::TEXT;
        RETURN;
    END IF;

    -- Enhanced timing validation: compare client-reported time with server-calculated time
    v_time_discrepancy := ABS(v_time_elapsed_seconds - v_client_reported_time);

    -- Log suspicious timing discrepancies for monitoring
    IF v_time_discrepancy > v_max_allowed_discrepancy THEN
        -- Log security event for suspicious timing
        PERFORM log_security_event(
            'suspicious_timing',
            p_game_session_id,
            p_player_id,
            NULL,
            jsonb_build_object(
                'question_index', p_question_index,
                'server_time', v_time_elapsed_seconds,
                'client_time', v_client_reported_time,
                'discrepancy', v_time_discrepancy,
                'max_allowed', v_max_allowed_discrepancy
            ),
            'warning'
        );
    END IF;

    -- Use server-calculated time for scoring to prevent timing manipulation
    -- But allow client time if it's reasonably close to server time
    IF v_time_discrepancy <= v_max_allowed_discrepancy THEN
        -- Use more accurate of the two times
        IF ABS(v_client_reported_time - v_time_elapsed_seconds) <= 1 THEN
            v_time_elapsed_seconds := LEAST(v_client_reported_time, v_time_elapsed_seconds);
        END IF;
    END IF;

    -- Get correct answer from stored questions
    SELECT correct_answer INTO v_correct_answer
    FROM game_session_questions
    WHERE game_session_id = p_game_session_id
      AND question_index = p_question_index;

    -- If we can't get the correct answer server-side, return error
    IF v_correct_answer IS NULL THEN
        RETURN QUERY SELECT FALSE, 0, 'Question validation not available'::TEXT;
        RETURN;
    END IF;

    -- Validate answer server-side
    v_is_correct := LOWER(TRIM(p_answer)) = LOWER(TRIM(v_correct_answer));

    -- Calculate points using validated server time
    IF v_is_correct THEN
        v_points := 100; -- Base points

        -- Speed bonus based on validated time
        IF v_time_elapsed_seconds <= 2 THEN
            v_points := v_points + 50;
        ELSIF v_time_elapsed_seconds < v_question_time_limit THEN
            DECLARE
                time_ratio NUMERIC := (v_time_elapsed_seconds - 2.0) / (v_question_time_limit - 2.0);
                bonus_points INTEGER := (50 * (1 - GREATEST(0, LEAST(1, time_ratio))))::INTEGER;
            BEGIN
                v_points := v_points + bonus_points;
            END;
        END IF;
    END IF;

    RETURN QUERY SELECT v_is_correct, v_points, v_error;
END;
$$ LANGUAGE plpgsql;

-- Function for atomic answer submission with transaction
CREATE OR REPLACE FUNCTION submit_answer_transaction(
    p_player_id UUID,
    p_game_session_id UUID,
    p_question_index INTEGER,
    p_answer TEXT,
    p_is_correct BOOLEAN,
    p_answer_time_seconds INTEGER,
    p_points_earned INTEGER
) RETURNS TABLE(new_score INTEGER) AS $$
DECLARE
    v_current_score INTEGER;
    v_new_score INTEGER;
BEGIN
    -- Start transaction
    BEGIN
        -- Get current score
        SELECT score INTO v_current_score
        FROM multiplayer_game_players
        WHERE id = p_player_id
        FOR UPDATE; -- Lock the row

        IF v_current_score IS NULL THEN
            RAISE EXCEPTION 'Player not found';
        END IF;

        -- Calculate new score
        v_new_score := v_current_score + p_points_earned;

        -- Update player score and answer status
        UPDATE multiplayer_game_players
        SET score = v_new_score,
            current_answer = p_answer,
            answer_time_seconds = p_answer_time_seconds,
            last_seen_at = NOW()
        WHERE id = p_player_id;

        -- Insert answer record
        INSERT INTO multiplayer_game_answers (
            game_session_id,
            player_id,
            question_index,
            answer,
            is_correct,
            answer_time_seconds,
            points_earned
        ) VALUES (
            p_game_session_id,
            p_player_id,
            p_question_index,
            p_answer,
            p_is_correct,
            p_answer_time_seconds,
            p_points_earned
        );

        -- Return new score
        RETURN QUERY SELECT v_new_score;

    EXCEPTION
        WHEN OTHERS THEN
            -- Transaction will be rolled back automatically
            RAISE EXCEPTION 'Failed to submit answer: %', SQLERRM;
    END;

END;
$$ LANGUAGE plpgsql;

-- Function to calculate points based on correctness and speed (legacy, kept for compatibility)
CREATE OR REPLACE FUNCTION calculate_answer_points(
    is_correct BOOLEAN,
    answer_time_seconds INTEGER,
    question_time_limit INTEGER DEFAULT 20
) RETURNS INTEGER AS $$
BEGIN
    IF NOT is_correct THEN
        RETURN 0;
    END IF;

    -- Base points for correct answer
    -- Bonus points for speed: faster answers get more points
    -- Max bonus: 50 points for answering in 2 seconds or less
    -- Min bonus: 0 points for answering in time limit or more
    IF answer_time_seconds <= 2 THEN
        RETURN 100 + 50; -- 150 points
    ELSIF answer_time_seconds >= question_time_limit THEN
        RETURN 100; -- 100 points
    ELSE
        -- Linear interpolation between 2 seconds (150 points) and time limit (100 points)
        DECLARE
            time_ratio NUMERIC := (answer_time_seconds - 2.0) / (question_time_limit - 2.0);
            bonus_points INTEGER := 50 - (time_ratio * 50)::INTEGER;
        BEGIN
            RETURN 100 + GREATEST(0, bonus_points);
        END;
    END IF;
END;
$$ LANGUAGE plpgsql;