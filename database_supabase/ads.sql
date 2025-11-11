-- Custom Ads Table
-- This table stores custom advertisements that can be displayed in the app
CREATE TABLE IF NOT EXISTS ads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,                           -- Ad title
    text TEXT NOT NULL,                            -- Ad content/text
    link_url TEXT,                                 -- Optional link to external content
    is_active BOOLEAN DEFAULT TRUE,                -- Whether the ad is currently active
    start_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(), -- When the ad becomes valid
    expiry_date TIMESTAMP WITH TIME ZONE NOT NULL, -- When the ad expires
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    -- Additional constraints to ensure data integrity
    CONSTRAINT valid_date_range CHECK (expiry_date > start_date),
    CONSTRAINT future_start_date CHECK (start_date >= '2020-01-01'::timestamp)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_ads_active_dates ON ads (is_active, start_date, expiry_date);
CREATE INDEX IF NOT EXISTS idx_ads_active ON ads (is_active) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_ads_expiry ON ads (expiry_date);

-- Insert sample ad data for testing
INSERT INTO ads (title, text, link_url, is_active, start_date, expiry_date) VALUES
('Nieuwe Bijbel Quiz Versie', 'Ontdek de nieuwe features in onze bijgewerkte app! Leer op een leuke manier meer over de Bijbel.', 'https://bijbelquiz.app/download', TRUE, NOW(), NOW() + INTERVAL '30 days'),
('Bijbel Studie Groepen', 'Doe mee met onze online bijbel studie groepen. Sluit je aan bij duizenden gelovigen wereldwijd.', 'https://bijbelquiz.app/groups', TRUE, NOW(), NOW() + INTERVAL '60 days'),
('Christelijke Muziek App', 'Luister naar de beste christelijke muziek terwijl je studeert. Gratis te downloaden!', 'https://example.com/christian-music', TRUE, NOW(), NOW() + INTERVAL '45 days'),
('Bijbel Vertaling Vergelijking', 'Vergelijk verschillende Bijbelvertalingen en verdiep je begrip van Gods Woord.', NULL, TRUE, NOW(), NOW() + INTERVAL '90 days')
ON CONFLICT (id) DO NOTHING;

-- Function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at column
CREATE TRIGGER update_ads_updated_at
    BEFORE UPDATE ON ads
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to automatically deactivate expired ads
CREATE OR REPLACE FUNCTION deactivate_expired_ads()
RETURNS void AS $$
BEGIN
    UPDATE ads 
    SET is_active = FALSE 
    WHERE expiry_date < NOW() AND is_active = TRUE;
END;
$$ LANGUAGE plpgsql;

-- Add a scheduled task to deactivate expired ads (if pg_cron extension is available)
-- This will run every hour to clean up expired ads
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_cron') THEN
        PERFORM cron.schedule('deactivate-expired-ads', '0 * * * *', 'SELECT deactivate_expired_ads();');
    END IF;
END
$$;

-- RLS (Row Level Security) setup
ALTER TABLE ads ENABLE ROW LEVEL SECURITY;

-- Create a policy to allow public read access to active ads
CREATE POLICY "Allow public read access to active ads" ON ads
    FOR SELECT TO authenticated, anon
    USING (
        is_active = TRUE 
        AND start_date <= NOW() 
        AND expiry_date > NOW()
    );

-- Create a policy for authenticated users to manage ads (for admin purposes)
CREATE POLICY "Allow authenticated users to manage ads" ON ads
    FOR ALL TO authenticated
    USING (true)
    WITH CHECK (true);

-- Add comments to document the table structure
COMMENT ON TABLE ads IS 'Stores custom advertisements that can be displayed in the app';
COMMENT ON COLUMN ads.id IS 'Unique identifier for the ad';
COMMENT ON COLUMN ads.title IS 'The headline/title of the advertisement';
COMMENT ON COLUMN ads.text IS 'The main content text of the advertisement';
COMMENT ON COLUMN ads.link_url IS 'Optional URL to link to when the ad is clicked';
COMMENT ON COLUMN ads.is_active IS 'Whether the ad is currently active and can be shown';
COMMENT ON COLUMN ads.start_date IS 'When the ad becomes valid for display';
COMMENT ON COLUMN ads.expiry_date IS 'When the ad expires and should no longer be shown';
COMMENT ON COLUMN ads.created_at IS 'When the ad was created in the database';
COMMENT ON COLUMN ads.updated_at IS 'When the ad was last modified';

-- Function to clean up old inactive ads (optional maintenance)
CREATE OR REPLACE FUNCTION cleanup_old_inactive_ads()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    -- Delete ads that expired more than 1 year ago and are inactive
    DELETE FROM ads 
    WHERE is_active = FALSE 
    AND expiry_date < (NOW() - INTERVAL '1 year');
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RAISE NOTICE 'Cleaned up % old inactive ads', deleted_count;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;