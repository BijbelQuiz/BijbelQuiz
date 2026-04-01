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
    FOR ALL USING ((select auth.uid()) = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    SET search_path = public, pg_temp;
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_user_sync_data_updated_at
    BEFORE UPDATE ON user_sync_data
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Enable Realtime for this table to allow real-time sync subscriptions
-- This fixes: "Unable to subscribe to changes with given parameters"
ALTER PUBLICATION supabase_realtime ADD TABLE user_sync_data;

-- Create devices table for tracking user devices
CREATE TABLE IF NOT EXISTS user_devices (
    device_id TEXT PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    device_name TEXT,
    device_type TEXT,
    last_sync TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on user_devices
ALTER TABLE user_devices ENABLE ROW LEVEL SECURITY;

-- Create policies for user_devices
CREATE POLICY "Users can view their own devices" ON user_devices
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage their own devices" ON user_devices
    FOR ALL USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_devices_user_id ON user_devices(user_id);
CREATE INDEX IF NOT EXISTS idx_user_devices_last_sync ON user_devices(last_sync);

-- Function to atomically sync data
CREATE OR REPLACE FUNCTION atomic_sync_data(target_user_id UUID, new_data JSONB)
RETURNS BOOLEAN AS $$
BEGIN
    SET search_path = public, pg_temp;
    INSERT INTO user_sync_data (user_id, data)
    VALUES (target_user_id, new_data)
    ON CONFLICT (user_id)
    DO UPDATE SET
        data = EXCLUDED.data,
        updated_at = NOW();
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to atomically add a device
CREATE OR REPLACE FUNCTION atomic_add_device(target_user_id UUID, device_id_param TEXT, device_name_param TEXT, device_type_param TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    SET search_path = public, pg_temp;
    INSERT INTO user_devices (device_id, user_id, device_name, device_type, last_sync)
    VALUES (device_id_param, target_user_id, device_name_param, device_type_param, NOW())
    ON CONFLICT (device_id)
    DO UPDATE SET
        last_sync = NOW();
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to atomically remove a device
CREATE OR REPLACE FUNCTION atomic_remove_device(target_user_id UUID, device_id_param TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    SET search_path = public, pg_temp;
    DELETE FROM user_devices
    WHERE device_id = device_id_param
    AND user_id = target_user_id;
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
