-- Create the questions_en table for storing English quiz questions
CREATE TABLE IF NOT EXISTS questions_en (
    id TEXT PRIMARY KEY,
    question TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    incorrect_answers TEXT[] NOT NULL, -- Array of incorrect answers
    difficulty INTEGER NOT NULL,
    type TEXT NOT NULL,
    categories TEXT[], -- Array of categories
    biblical_reference TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_questions_en_difficulty ON questions_en(difficulty);
CREATE INDEX IF NOT EXISTS idx_questions_en_type ON questions_en(type);
CREATE INDEX IF NOT EXISTS idx_questions_en_categories ON questions_en USING GIN(categories);
CREATE INDEX IF NOT EXISTS idx_questions_en_created_at ON questions_en(created_at);

-- RLS (Row Level Security) setup
ALTER TABLE questions_en ENABLE ROW LEVEL SECURITY;

-- Policy to allow authenticated users to read questions
CREATE POLICY "Allow authenticated users to read questions_en" ON questions_en
    FOR SELECT USING (auth.role() = 'authenticated' OR auth.role() = 'anon');

-- Policy to allow service role to manage questions
CREATE POLICY "Allow service role to manage questions_en" ON questions_en
    FOR ALL USING (auth.role() = 'service_role');

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_questions_en_updated_at
    BEFORE UPDATE ON questions_en
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
