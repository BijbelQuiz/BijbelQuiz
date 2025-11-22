-- Game session questions table for server-side question storage
CREATE TABLE IF NOT EXISTS game_session_questions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    game_session_id UUID NOT NULL REFERENCES multiplayer_game_sessions(id) ON DELETE CASCADE,
    question_index INTEGER NOT NULL,
    question_id UUID NOT NULL, -- References questions table
    question_text TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    options JSONB, -- For multiple choice questions
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(game_session_id, question_index)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_game_session_questions_game_session_id ON game_session_questions(game_session_id);
CREATE INDEX IF NOT EXISTS idx_game_session_questions_question_index ON game_session_questions(question_index);

-- RLS policies
ALTER TABLE game_session_questions ENABLE ROW LEVEL SECURITY;

-- Allow organizer to read/write questions for their session
CREATE POLICY "Organizer can manage questions in their game session" ON game_session_questions
    FOR ALL USING (
        game_session_id IN (
            SELECT id FROM multiplayer_game_sessions
            WHERE organizer_id = auth.uid()
        )
    );

-- Allow players to read questions in their game session
CREATE POLICY "Players can read questions in their game session" ON game_session_questions
    FOR SELECT USING (
        game_session_id IN (
            SELECT id FROM multiplayer_game_sessions
            WHERE organizer_id = auth.uid()
        ) OR
        EXISTS (
            SELECT 1 FROM multiplayer_game_players
            WHERE game_session_id = game_session_questions.game_session_id
            AND player_id = auth.uid()
        )
    );