-- Users table to store public user data
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clerk_id TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- User stats table
CREATE TABLE user_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    stars INT DEFAULT 0,
    score INT DEFAULT 0,
    achievements JSONB,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    incorrect_answers INT DEFAULT 0,
    updated_at TIMESTAMPTZ
);

-- Purchased items table
CREATE TABLE purchased_items (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_sku TEXT NOT NULL,
    purchased_at TIMESTAMPTZ DEFAULT now()
);

-- User progress table
CREATE TABLE user_progress (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id TEXT NOT NULL,
    progress FLOAT DEFAULT 0,
    stars INT DEFAULT 0,
    completed_at TIMESTAMPTZ,
    UNIQUE(user_id, lesson_id)
);

-- Follows table for social features
CREATE TABLE follows (
    follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now(),
    PRIMARY KEY (follower_id, following_id)
);

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at on user_stats table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON user_stats
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
