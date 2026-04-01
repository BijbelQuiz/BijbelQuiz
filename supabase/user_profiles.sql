-- User profiles table for storing user information and usernames
CREATE TABLE IF NOT EXISTS user_profiles (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_username ON user_profiles(username);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_profiles_updated_at ON user_profiles(updated_at);

-- Enable RLS (Row Level Security)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create policies so users can read all non-deleted profiles but only update their own
CREATE POLICY "Users can view all non-deleted profiles" ON user_profiles
    FOR SELECT USING (deleted_at IS NULL);

CREATE POLICY "Users can update their own non-deleted profile" ON user_profiles
    FOR UPDATE USING ((select auth.uid()) = user_id AND deleted_at IS NULL);

CREATE POLICY "Users can insert their own profile" ON user_profiles
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL AND auth.uid() = user_id AND deleted_at IS NULL);

-- Allow users to "soft delete" their own profile
CREATE POLICY "Users can soft delete their own profile" ON user_profiles
    FOR UPDATE USING ((select auth.uid()) = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    SET search_path = public, pg_temp;
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_user_profiles_updated_at();

-- Create following/followers relationships table
CREATE TABLE IF NOT EXISTS user_follows (
    follower_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    following_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (follower_id, following_id),
    CHECK (follower_id != following_id)
);

-- Enable RLS on user_follows
ALTER TABLE user_follows ENABLE ROW LEVEL SECURITY;

-- Create policies for user_follows
CREATE POLICY "Users can view all follows" ON user_follows
    FOR SELECT USING (true);

CREATE POLICY "Users can manage their own follows" ON user_follows
    FOR ALL USING (auth.uid() = follower_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_follows_follower ON user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following ON user_follows(following_id);

-- Function to get followers count
CREATE OR REPLACE FUNCTION get_followers_count(target_user_id UUID)
RETURNS BIGINT AS $$
DECLARE
    count_val BIGINT;
BEGIN
    SET search_path = public, pg_temp;
    SELECT COUNT(*) INTO count_val
    FROM user_follows
    WHERE following_id = target_user_id;
    RETURN count_val;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get following count
CREATE OR REPLACE FUNCTION get_following_count(target_user_id UUID)
RETURNS BIGINT AS $$
DECLARE
    count_val BIGINT;
BEGIN
    SET search_path = public, pg_temp;
    SELECT COUNT(*) INTO count_val
    FROM user_follows
    WHERE follower_id = target_user_id;
    RETURN count_val;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user is following another user
CREATE OR REPLACE FUNCTION is_following(follower_user_id UUID, following_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    SET search_path = public, pg_temp;
    RETURN EXISTS (
        SELECT 1 FROM user_follows
        WHERE follower_id = follower_user_id
        AND following_id = following_user_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- General function to handle updated_at timestamps (for compatibility)
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    SET search_path = public, pg_temp;
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to increment a value in a JSONB object
CREATE OR REPLACE FUNCTION increment_value(data_ref JSONB, key_name TEXT, increment_amount INTEGER DEFAULT 1)
RETURNS JSONB AS $$
BEGIN
    SET search_path = public, pg_temp;
    RETURN jsonb_set(data_ref, ARRAY[key_name], COALESCE((data_ref->key_name)::INTEGER, 0) + increment_amount, true);
END;
$$ LANGUAGE plpgsql;
