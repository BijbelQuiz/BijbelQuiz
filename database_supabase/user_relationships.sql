-- User relationships table for following/followers functionality
CREATE TABLE IF NOT EXISTS user_relationships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    follower_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    followed_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    UNIQUE(follower_user_id, followed_user_id),
    CHECK (follower_user_id != followed_user_id) -- Prevent self-following
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_relationships_follower ON user_relationships(follower_user_id);
CREATE INDEX IF NOT EXISTS idx_user_relationships_followed ON user_relationships(followed_user_id);
CREATE INDEX IF NOT EXISTS idx_user_relationships_created_at ON user_relationships(created_at);

-- Enable RLS (Row Level Security)
ALTER TABLE user_relationships ENABLE ROW LEVEL SECURITY;

-- Create policies for relationship management
CREATE POLICY "Users can view all relationships" ON user_relationships
    FOR SELECT USING (true);

CREATE POLICY "Users can manage their own following relationships" ON user_relationships
    FOR ALL USING (auth.uid() = follower_user_id);

-- Create function to get followers count for a user
CREATE OR REPLACE FUNCTION get_followers_count(user_uuid UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM user_relationships
        WHERE followed_user_id = user_uuid
    );
END;
$$ LANGUAGE plpgsql;

-- Create function to get following count for a user
CREATE OR REPLACE FUNCTION get_following_count(user_uuid UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM user_relationships
        WHERE follower_user_id = user_uuid
    );
END;
$$ LANGUAGE plpgsql;

-- Create function to check if user A follows user B
CREATE OR REPLACE FUNCTION is_following(follower_uuid UUID, followed_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM user_relationships
        WHERE follower_user_id = follower_uuid
        AND followed_user_id = followed_uuid
    );
END;
$$ LANGUAGE plpgsql;