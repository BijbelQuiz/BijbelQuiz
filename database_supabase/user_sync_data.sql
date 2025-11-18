-- User sync data table for storing synchronized data per user
CREATE TABLE IF NOT EXISTS user_sync_data (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    data JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_user_sync_data_user_id ON user_sync_data(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sync_data_updated_at ON user_sync_data(updated_at);

-- Enable RLS (Row Level Security)
ALTER TABLE user_sync_data ENABLE ROW LEVEL SECURITY;

-- Create policy so users can only access their own data
CREATE POLICY "Users can only access their own sync data" ON user_sync_data
    FOR ALL USING (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_user_sync_data_updated_at
    BEFORE UPDATE ON user_sync_data
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();