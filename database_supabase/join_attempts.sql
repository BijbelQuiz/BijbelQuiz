-- Join attempts table for rate limiting
CREATE TABLE IF NOT EXISTS join_attempts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_identifier TEXT NOT NULL, -- User ID or device fingerprint
    game_code VARCHAR(8) NOT NULL,
    attempted_at TIMESTAMPTZ DEFAULT NOW(),
    user_agent TEXT
);

-- Index for performance
CREATE INDEX IF NOT EXISTS idx_join_attempts_user_game_code_time ON join_attempts(user_identifier, game_code, attempted_at);
CREATE INDEX IF NOT EXISTS idx_join_attempts_cleanup ON join_attempts(attempted_at);

-- RLS policies
ALTER TABLE join_attempts ENABLE ROW LEVEL SECURITY;

-- Allow inserts for rate limiting (service role only)
CREATE POLICY "Service can insert join attempts" ON join_attempts
    FOR INSERT WITH CHECK (true);

-- Allow reads for rate limiting checks (service role only)
CREATE POLICY "Service can read join attempts" ON join_attempts
    FOR SELECT USING (true);

-- Function to check rate limit
CREATE OR REPLACE FUNCTION check_join_rate_limit(
    p_user_identifier TEXT,
    p_game_code VARCHAR(8),
    p_max_attempts INTEGER DEFAULT 5,
    p_window_minutes INTEGER DEFAULT 15
) RETURNS BOOLEAN AS $$
DECLARE
    attempt_count INTEGER;
    v_game_session_id UUID;
BEGIN
    -- Count attempts in the time window
    SELECT COUNT(*) INTO attempt_count
    FROM join_attempts
    WHERE user_identifier = p_user_identifier
      AND game_code = p_game_code
      AND attempted_at > NOW() - INTERVAL '1 minute' * p_window_minutes;

    -- Get game session ID for logging
    SELECT id INTO v_game_session_id
    FROM multiplayer_game_sessions
    WHERE game_code = p_game_code;

    -- Log rate limit violations
    IF attempt_count >= p_max_attempts THEN
        PERFORM log_security_event(
            'rate_limit_exceeded',
            v_game_session_id,
            NULL,
            p_user_identifier,
            jsonb_build_object(
                'game_code', p_game_code,
                'attempt_count', attempt_count,
                'max_attempts', p_max_attempts,
                'window_minutes', p_window_minutes
            ),
            'warning'
        );
    END IF;

    -- Return true if under limit, false if rate limited
    RETURN attempt_count < p_max_attempts;
END;
$$ LANGUAGE plpgsql;

-- Function to record join attempt
CREATE OR REPLACE FUNCTION record_join_attempt(
    p_user_identifier TEXT,
    p_game_code VARCHAR(8),
    p_user_agent TEXT DEFAULT ''
) RETURNS VOID AS $$
BEGIN
    INSERT INTO join_attempts (user_identifier, game_code, user_agent)
    VALUES (p_user_identifier, p_game_code, p_user_agent);
END;
$$ LANGUAGE plpgsql;

-- Cleanup old attempts (run periodically)
CREATE OR REPLACE FUNCTION cleanup_old_join_attempts() RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM join_attempts
    WHERE attempted_at < NOW() - INTERVAL '1 hour';

    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;