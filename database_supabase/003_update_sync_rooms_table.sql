-- Add missing columns to sync_rooms table for improved sync system
-- This migration adds metadata, updated_at columns and indexes for better performance

-- Add missing columns
ALTER TABLE sync_rooms 
ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}',
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_sync_rooms_room_id ON sync_rooms(room_id);
CREATE INDEX IF NOT EXISTS idx_sync_rooms_updated_at ON sync_rooms(updated_at);
CREATE INDEX IF NOT EXISTS idx_sync_rooms_devices ON sync_rooms USING GIN(devices);

-- Enable RLS (Row Level Security) for sync_rooms table
ALTER TABLE sync_rooms ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations (for now, can be restricted later)
DROP POLICY IF EXISTS "Allow all operations on sync_rooms" ON sync_rooms;
CREATE POLICY "Allow all operations on sync_rooms" ON sync_rooms
  FOR ALL USING (true) WITH CHECK (true);

-- Add comments for documentation
COMMENT ON COLUMN sync_rooms.metadata IS 'Additional metadata for the sync room (version, room type, etc.)';
COMMENT ON COLUMN sync_rooms.updated_at IS 'Timestamp of the last update to this room';

-- Update existing records to have default values
UPDATE sync_rooms 
SET updated_at = COALESCE(updated_at, created_at) 
WHERE updated_at IS NULL;

-- Grant necessary permissions
GRANT ALL ON sync_rooms TO anon, authenticated;