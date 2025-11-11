-- Migration script to fix emoji reactions for anonymous users
-- This converts existing anonymous_user_2024 reactions to unique user IDs

-- Step 1: Create a temporary table to track new unique anonymous user assignments
CREATE TEMPORARY TABLE temp_anonymous_user_mapping AS
WITH anonymous_reactions AS (
    SELECT DISTINCT 
        mr.user_id,
        mr.message_id,
        mr.emoji,
        ROW_NUMBER() OVER (PARTITION BY mr.user_id, mr.message_id ORDER BY mr.created_at) as rn
    FROM message_reactions mr
    WHERE mr.user_id = 'anonymous_user_2024'
),
unique_assignments AS (
    SELECT 
        ar.user_id as old_user_id,
        ar.message_id,
        ar.emoji,
        ar.rn,
        -- Generate unique ID for each user+message combination
        'anonymous_user_' || 
        EXTRACT(EPOCH FROM NOW())::bigint || '_' || 
        ROW_NUMBER() OVER (ORDER BY ar.user_id, ar.message_id, ar.emoji)::text as new_user_id
    FROM anonymous_reactions ar
)
SELECT DISTINCT
    old_user_id,
    new_user_id
FROM unique_assignments;

-- Step 2: Update the message_reactions table with new unique user IDs
-- This preserves existing reactions but gives each anonymous user a unique identity
UPDATE message_reactions 
SET user_id = temp.new_user_id
FROM temp_anonymous_user_mapping temp
WHERE message_reactions.user_id = temp.old_user_id;

-- Step 3: Clean up the temporary table
DROP TABLE temp_anonymous_user_mapping;

-- Step 4: Verify the migration
-- Check that all reactions now have unique user IDs
SELECT 
    user_id,
    COUNT(*) as reaction_count,
    COUNT(DISTINCT message_id) as messages_reacted_to
FROM message_reactions
WHERE user_id LIKE 'anonymous_user_%'
GROUP BY user_id
ORDER BY reaction_count DESC;

-- Optional: Show summary statistics
SELECT 
    'Before migration' as status,
    COUNT(*) as total_reactions,
    COUNT(DISTINCT user_id) as unique_users
FROM message_reactions
WHERE user_id = 'anonymous_user_2024'

UNION ALL

SELECT 
    'After migration' as status,
    COUNT(*) as total_reactions,
    COUNT(DISTINCT user_id) as unique_users
FROM message_reactions
WHERE user_id LIKE 'anonymous_user_%'
AND user_id != 'anonymous_user_2024';

-- Step 5: Update database policies to handle new ID format
-- Note: This is already done in the messages.sql file, but including here for reference
/*
-- These policies are already updated in messages.sql:
-- Update policy for anonymous users (the wildcard now matches our new format)
ALTER POLICY "Users can update their own reactions" ON message_reactions
    FOR UPDATE TO authenticated, anon
    USING (user_id LIKE 'anonymous_user_%' OR auth.uid()::text = user_id);

ALTER POLICY "Users can delete their own reactions" ON message_reactions
    FOR DELETE TO authenticated, anon
    USING (user_id LIKE 'anonymous_user_%' OR auth.uid()::text = user_id);
*/