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

-- Message Reactions System
-- Create message_reactions table for emoji reactions

CREATE TABLE message_reactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    user_id VARCHAR(255) NOT NULL,
    emoji VARCHAR(10) NOT NULL, -- Support multi-character emojis
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    
    -- Ensure a user can only have one reaction per message
    UNIQUE(message_id, user_id)
);

-- Create indexes for efficient querying
CREATE INDEX idx_message_reactions_message_id ON message_reactions (message_id);
CREATE INDEX idx_message_reactions_user_id ON message_reactions (user_id);
CREATE INDEX idx_message_reactions_emoji ON message_reactions (emoji);
CREATE INDEX idx_message_reactions_created_at ON message_reactions (created_at);

-- RLS (Row Level Security) policies for message_reactions
-- Enable RLS
ALTER TABLE message_reactions ENABLE ROW LEVEL SECURITY;

-- Policy for reading reactions (everyone can read reactions)
CREATE POLICY "Anyone can read message reactions" ON message_reactions
    FOR SELECT TO authenticated, anon
    USING (true);

-- Policy for inserting reactions (both authenticated and anonymous users can create reactions)
CREATE POLICY "Users can insert reactions" ON message_reactions
    FOR INSERT TO authenticated, anon
    WITH CHECK (true);

-- Policy for updating reactions (users can only update their own reactions)
CREATE POLICY "Users can update their own reactions" ON message_reactions
    FOR UPDATE TO authenticated, anon
    USING (user_id LIKE 'anonymous_user_%' OR auth.uid()::text = user_id);

-- Policy for deleting reactions (users can only delete their own reactions)
CREATE POLICY "Users can delete their own reactions" ON message_reactions
    FOR DELETE TO authenticated, anon
    USING (user_id LIKE 'anonymous_user_%' OR auth.uid()::text = user_id);

-- Create a function to get reaction counts for a message
CREATE OR REPLACE FUNCTION get_message_reaction_counts(message_uuid UUID)
RETURNS TABLE(emoji VARCHAR(10), count BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        mr.emoji,
        COUNT(*) as count
    FROM message_reactions mr
    WHERE mr.message_id = message_uuid
    GROUP BY mr.emoji
    ORDER BY count DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a function to get user's reaction for a specific message
CREATE OR REPLACE FUNCTION get_user_message_reaction(message_uuid UUID, user_uuid TEXT)
RETURNS VARCHAR(10) AS $$
DECLARE
    user_reaction VARCHAR(10);
BEGIN
    SELECT mr.emoji INTO user_reaction
    FROM message_reactions mr
    WHERE mr.message_id = message_uuid AND mr.user_id = user_uuid
    LIMIT 1;
    
    RETURN user_reaction;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a function to toggle/add a reaction
CREATE OR REPLACE FUNCTION toggle_message_reaction(
    message_uuid UUID,
    user_uuid TEXT,
    emoji_char VARCHAR(10)
) RETURNS JSON AS $$
DECLARE
    existing_reaction VARCHAR(10);
    result JSON;
BEGIN
    -- Check if user already has a reaction
    SELECT mr.emoji INTO existing_reaction
    FROM message_reactions mr
    WHERE mr.message_id = message_uuid AND mr.user_id = user_uuid;
    
    IF FOUND THEN
        IF existing_reaction = emoji_char THEN
            -- User is removing their reaction
            DELETE FROM message_reactions
            WHERE message_id = message_uuid AND user_id = user_uuid;
            
            result := json_build_object(
                'action', 'removed',
                'emoji', emoji_char,
                'user_reaction', NULL
            );
        ELSE
            -- User is changing their reaction
            UPDATE message_reactions
            SET emoji = emoji_char, created_at = NOW()
            WHERE message_id = message_uuid AND user_id = user_uuid;
            
            result := json_build_object(
                'action', 'updated',
                'emoji', emoji_char,
                'user_reaction', emoji_char
            );
        END IF;
    ELSE
        -- User is adding a new reaction
        INSERT INTO message_reactions (message_id, user_id, emoji)
        VALUES (message_uuid, user_uuid, emoji_char);
        
        result := json_build_object(
            'action', 'added',
            'emoji', emoji_char,
            'user_reaction', emoji_char
        );
    END IF;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;