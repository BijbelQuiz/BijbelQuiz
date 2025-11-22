-- Multiplayer game sessions table
CREATE TABLE IF NOT EXISTS multiplayer_game_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    game_code VARCHAR(8) UNIQUE NOT NULL,
    organizer_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'waiting' CHECK (status IN ('waiting', 'active', 'finished')),
    game_settings JSONB NOT NULL DEFAULT '{
        "num_questions": 10,
        "time_limit_minutes": null,
        "question_time_seconds": 20,
        "max_players": 8
    }',
    current_question_index INTEGER DEFAULT 0,
    current_question_start_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_multiplayer_game_sessions_game_code ON multiplayer_game_sessions(game_code);
CREATE INDEX IF NOT EXISTS idx_multiplayer_game_sessions_organizer_id ON multiplayer_game_sessions(organizer_id);
CREATE INDEX IF NOT EXISTS idx_multiplayer_game_sessions_status ON multiplayer_game_sessions(status);

-- Security audit log table
CREATE TABLE IF NOT EXISTS multiplayer_security_log (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    game_session_id UUID REFERENCES multiplayer_game_sessions(id) ON DELETE CASCADE,
    player_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
    user_identifier TEXT, -- For anonymous users
    ip_address INET,
    details JSONB,
    severity VARCHAR(20) DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'error', 'critical')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for security log
CREATE INDEX IF NOT EXISTS idx_multiplayer_security_log_event_type ON multiplayer_security_log(event_type);
CREATE INDEX IF NOT EXISTS idx_multiplayer_security_log_game_session ON multiplayer_security_log(game_session_id);
CREATE INDEX IF NOT EXISTS idx_multiplayer_security_log_player ON multiplayer_security_log(player_id);
CREATE INDEX IF NOT EXISTS idx_multiplayer_security_log_created_at ON multiplayer_security_log(created_at);

-- Function to log security events
CREATE OR REPLACE FUNCTION log_security_event(
    p_event_type VARCHAR(50),
    p_game_session_id UUID DEFAULT NULL,
    p_player_id UUID DEFAULT NULL,
    p_user_identifier TEXT DEFAULT NULL,
    p_details JSONB DEFAULT NULL,
    p_severity VARCHAR(20) DEFAULT 'info'
) RETURNS VOID AS $$
BEGIN
    INSERT INTO multiplayer_security_log (
        event_type,
        game_session_id,
        player_id,
        user_identifier,
        details,
        severity
    ) VALUES (
        p_event_type,
        p_game_session_id,
        p_player_id,
        p_user_identifier,
        p_details,
        p_severity
    );
END;
$$ LANGUAGE plpgsql;

-- RLS policies
ALTER TABLE multiplayer_game_sessions ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read game sessions (for joining)
CREATE POLICY "Anyone can read multiplayer game sessions" ON multiplayer_game_sessions
    FOR SELECT USING (true);

-- Only organizer can update their game session
CREATE POLICY "Organizer can update their game session" ON multiplayer_game_sessions
    FOR UPDATE USING (organizer_id = auth.uid());

-- Only organizer can insert their game session
CREATE POLICY "Organizer can insert their game session" ON multiplayer_game_sessions
    FOR INSERT WITH CHECK (organizer_id = auth.uid());

-- Only organizer can delete their game session
CREATE POLICY "Organizer can delete their game session" ON multiplayer_game_sessions
    FOR DELETE USING (organizer_id = auth.uid());

-- Function to generate unique 8-character game codes
CREATE OR REPLACE FUNCTION generate_game_code()
RETURNS VARCHAR(8) AS $$
DECLARE
    code VARCHAR(8);
    exists_already BOOLEAN;
BEGIN
    LOOP
        -- Generate random 8-character code using uppercase letters and numbers
        -- Use more entropy by combining multiple random sources
        code := UPPER(SUBSTRING(MD5(RANDOM()::TEXT || RANDOM()::TEXT || NOW()::TEXT) FROM 1 FOR 8));
        -- Check if code already exists
        SELECT EXISTS(SELECT 1 FROM multiplayer_game_sessions WHERE game_code = code) INTO exists_already;
        EXIT WHEN NOT exists_already;
    END LOOP;
    RETURN code;
END;
$$ LANGUAGE plpgsql;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_multiplayer_game_sessions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER trigger_update_multiplayer_game_sessions_updated_at
    BEFORE UPDATE ON multiplayer_game_sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_multiplayer_game_sessions_updated_at();

-- Function to shuffle and store questions server-side
CREATE OR REPLACE FUNCTION shuffle_and_store_questions(
    p_game_session_id UUID,
    p_questions JSONB
) RETURNS VOID AS $$
DECLARE
    question_record JSONB;
    shuffled_indices INTEGER[];
    i INTEGER;
BEGIN
    -- Create array of indices and shuffle them
    shuffled_indices := ARRAY(SELECT generate_series(0, jsonb_array_length(p_questions) - 1));
    shuffled_indices := ARRAY(SELECT unnest(shuffled_indices) ORDER BY RANDOM());

    -- Clear existing questions for this session
    DELETE FROM game_session_questions WHERE game_session_id = p_game_session_id;

    -- Insert questions in shuffled order
    FOR i IN 1..array_length(shuffled_indices, 1) LOOP
        question_record := p_questions->shuffled_indices[i-1];
        INSERT INTO game_session_questions (
            game_session_id,
            question_index,
            question_id,
            question_text,
            correct_answer,
            options
        ) VALUES (
            p_game_session_id,
            i-1,
            gen_random_uuid(), -- Generate a UUID for question_id
            question_record->>'question',
            question_record->>'correctAnswer',
            question_record->'incorrectAnswers'
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function to check if game session can accept more players
CREATE OR REPLACE FUNCTION can_join_game_session(
    p_game_session_id UUID,
    p_player_id UUID
) RETURNS TABLE(
    can_join BOOLEAN,
    reason TEXT
) AS $$
DECLARE
    v_max_players INTEGER;
    v_current_players INTEGER;
    v_is_already_joined BOOLEAN;
    v_game_status VARCHAR(20);
BEGIN
    -- Get game settings and status
    SELECT
        (game_settings->>'max_players')::INTEGER,
        status
    INTO v_max_players, v_game_status
    FROM multiplayer_game_sessions
    WHERE id = p_game_session_id;

    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Game session not found'::TEXT;
        RETURN;
    END IF;

    -- Check if game is still accepting players
    IF v_game_status != 'waiting' THEN
        RETURN QUERY SELECT FALSE, 'Game has already started'::TEXT;
        RETURN;
    END IF;

    -- Check if player is already in the game
    SELECT EXISTS(
        SELECT 1 FROM multiplayer_game_players
        WHERE game_session_id = p_game_session_id
        AND player_id = p_player_id
    ) INTO v_is_already_joined;

    IF v_is_already_joined THEN
        RETURN QUERY SELECT TRUE, 'Already joined'::TEXT;
        RETURN;
    END IF;

    -- Count current players
    SELECT COUNT(*) INTO v_current_players
    FROM multiplayer_game_players
    WHERE game_session_id = p_game_session_id;

    -- Check player limit
    IF v_current_players >= v_max_players THEN
        -- Log when game is full
        PERFORM log_security_event(
            'game_full_attempt',
            p_game_session_id,
            p_player_id,
            NULL,
            jsonb_build_object(
                'current_players', v_current_players,
                'max_players', v_max_players
            ),
            'info'
        );
        RETURN QUERY SELECT FALSE, 'Game is full'::TEXT;
        RETURN;
    END IF;

    RETURN QUERY SELECT TRUE, 'Can join'::TEXT;
END;
$$ LANGUAGE plpgsql;