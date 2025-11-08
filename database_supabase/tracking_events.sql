-- Create the tracking_events table for storing analytics events from the app
CREATE TABLE IF NOT EXISTS tracking_events (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    event_type TEXT NOT NULL,`
    event_name TEXT NOT NULL,
    properties JSONB,
    timestamp TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    screen_name TEXT,
    session_id TEXT,
    device_info TEXT,
    app_version TEXT,
    build_number TEXT,
    platform TEXT
);

-- Create indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_tracking_events_timestamp ON tracking_events(timestamp);
CREATE INDEX IF NOT EXISTS idx_tracking_events_event_name ON tracking_events(event_name);
CREATE INDEX IF NOT EXISTS idx_tracking_events_user_id ON tracking_events(user_id);
CREATE INDEX IF NOT EXISTS idx_tracking_events_session_id ON tracking_events(session_id);

-- Enable Row Level Security
ALTER TABLE tracking_events ENABLE ROW LEVEL SECURITY;

-- Policy to allow anon users to insert tracking events
CREATE POLICY "Allow anon users to insert tracking events" ON tracking_events
FOR INSERT TO anon
WITH CHECK (true);

-- Policy to allow service role access to tracking events
CREATE POLICY "Allow service role access to tracking events" ON tracking_events
FOR ALL TO service_role
USING (true);