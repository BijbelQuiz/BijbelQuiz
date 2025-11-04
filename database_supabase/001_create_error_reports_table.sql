-- Create the error_reports table for storing error reports from the app
CREATE TABLE IF NOT EXISTS error_reports (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    error_type TEXT NOT NULL,
    error_message TEXT NOT NULL,
    user_message TEXT,
    error_code TEXT,
    stack_trace TEXT,
    context TEXT,  -- JSON string containing additional context
    question_id TEXT,
    additional_info TEXT,  -- JSON string containing additional information
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    device_info TEXT,
    app_version TEXT,
    build_number TEXT
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_error_reports_timestamp ON error_reports(timestamp);
CREATE INDEX IF NOT EXISTS idx_error_reports_error_type ON error_reports(error_type);
CREATE INDEX IF NOT EXISTS idx_error_reports_user_id ON error_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_error_reports_question_id ON error_reports(question_id);

-- RLS (Row Level Security) setup - you might want to adjust this based on your security needs
ALTER TABLE error_reports ENABLE ROW LEVEL SECURITY;

-- Policy to allow anon users to insert error reports (for unauthenticated bug reports)
CREATE POLICY "Allow anon users to insert error reports" ON error_reports
    FOR INSERT WITH CHECK (true);

-- Example policy to allow service role to access all records
CREATE POLICY "Allow service role access to error reports" ON error_reports
    FOR ALL USING (auth.role() = 'service_role');