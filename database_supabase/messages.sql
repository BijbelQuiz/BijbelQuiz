-- SQL to create the messages table in Supabase

CREATE TABLE messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    expiration_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    created_by VARCHAR(255)
);

-- Create an index on expiration_date for efficient querying of active messages
CREATE INDEX idx_messages_expiration_date ON messages (expiration_date);

-- Create an index on created_at for ordering messages
CREATE INDEX idx_messages_created_at ON messages (created_at);

-- RLS (Row Level Security) policies if needed
-- Enable RLS
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Policy for reading messages (everyone can read active messages)
CREATE POLICY "Anyone can read active messages" ON messages
    FOR SELECT TO authenticated, anon
    USING (expiration_date IS NULL OR expiration_date > NOW());

-- Policy for inserting messages (only authenticated users with proper roles)
CREATE POLICY "Authenticated users can insert messages" ON messages
    FOR INSERT TO authenticated
    WITH CHECK (auth.role() = 'authenticated');

-- Policy for updating messages (only authenticated users with proper roles)
CREATE POLICY "Authenticated users can update messages" ON messages
    FOR UPDATE TO authenticated
    USING (auth.role() = 'authenticated');

-- Policy for deleting messages (only authenticated users with proper roles)
CREATE POLICY "Authenticated users can delete messages" ON messages
    FOR DELETE TO authenticated
    USING (auth.role() = 'authenticated');