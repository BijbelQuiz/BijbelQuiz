-- Create the questions table for storing quiz questions
CREATE TABLE IF NOT EXISTS questions (
    id TEXT PRIMARY KEY,
    vraag TEXT NOT NULL,
    juiste_antwoord TEXT NOT NULL,
    foute_antwoorden TEXT[] NOT NULL, -- Array of incorrect answers
    moeilijkheidsgraad INTEGER NOT NULL,
    type TEXT NOT NULL,
    categories TEXT[], -- Array of categories
    biblical_reference TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_questions_moeilijkheidsgraad ON questions(moeilijkheidsgraad);
CREATE INDEX IF NOT EXISTS idx_questions_type ON questions(type);
CREATE INDEX IF NOT EXISTS idx_questions_categories ON questions USING GIN(categories);
CREATE INDEX IF NOT EXISTS idx_questions_created_at ON questions(created_at);

-- RLS (Row Level Security) setup
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

-- Policy to allow authenticated users to read questions
CREATE POLICY "Allow authenticated users to read questions" ON questions
    FOR SELECT USING ((select auth.role()) = 'authenticated' OR (select auth.role()) = 'anon');

-- Policy to allow service role to manage questions
CREATE POLICY "Allow service role to manage questions" ON questions
    FOR ALL USING ((select auth.role()) = 'service_role');

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_questions_updated_at
    BEFORE UPDATE ON questions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();