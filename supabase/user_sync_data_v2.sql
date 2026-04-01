-- ============================================
-- BQID SYNC SYSTEM V2 - Database Schema
-- Complete refactor with versioning and atomic operations
-- ============================================

-- Drop old tables if they exist (for migration)
-- NOTE: Run this only during migration, comment out for new installs
-- DROP TABLE IF EXISTS user_sync_queue CASCADE;
-- DROP TABLE IF EXISTS user_sync_devices CASCADE;
-- DROP TABLE IF EXISTS user_sync_data_v2 CASCADE;
-- DROP TABLE IF EXISTS user_sync_metadata CASCADE;

-- ============================================
-- Main sync data table with versioning
-- ============================================
CREATE TABLE IF NOT EXISTS user_sync_data_v2 (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    data_key TEXT NOT NULL, -- 'game_stats', 'settings', 'lesson_progress', etc.
    data JSONB NOT NULL DEFAULT '{}',
    version INTEGER NOT NULL DEFAULT 1, -- Monotonically increasing version for optimistic locking
    device_id TEXT, -- Which device last modified this data
    modified_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    
    PRIMARY KEY (user_id, data_key)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_user_sync_data_v2_user_id ON user_sync_data_v2(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sync_data_v2_modified_at ON user_sync_data_v2(modified_at);
CREATE INDEX IF NOT EXISTS idx_user_sync_data_v2_version ON user_sync_data_v2(version);

-- Enable RLS
ALTER TABLE user_sync_data_v2 ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only access their own data
CREATE POLICY "Users can only access their own sync data v2" ON user_sync_data_v2
    FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- Sync metadata table for tracking last sync per device
-- ============================================
CREATE TABLE IF NOT EXISTS user_sync_metadata (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    last_sync_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    last_sync_version INTEGER DEFAULT 0,
    device_info JSONB DEFAULT '{}', -- { "os": "android", "version": "1.2.3", "model": "Pixel 6" }
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    
    PRIMARY KEY (user_id, device_id)
);

CREATE INDEX IF NOT EXISTS idx_user_sync_metadata_user_id ON user_sync_metadata(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sync_metadata_last_sync ON user_sync_metadata(last_sync_at);

ALTER TABLE user_sync_metadata ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own sync metadata" ON user_sync_metadata
    FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- Sync queue table for server-side queue management (optional, for advanced use)
-- ============================================
CREATE TABLE IF NOT EXISTS user_sync_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    data_key TEXT NOT NULL,
    data JSONB NOT NULL,
    version INTEGER NOT NULL,
    status TEXT DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 5,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    processed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_user_sync_queue_user_id ON user_sync_queue(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sync_queue_status ON user_sync_queue(status);
CREATE INDEX IF NOT EXISTS idx_user_sync_queue_created_at ON user_sync_queue(created_at);

ALTER TABLE user_sync_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own sync queue" ON user_sync_queue
    FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- Server-Side Functions for Atomic Operations
-- ============================================

-- Function: Atomic upsert with optimistic locking
-- Returns: JSON with { success: boolean, version: integer, conflict: boolean, data: jsonb }
CREATE OR REPLACE FUNCTION atomic_sync_upsert(
    p_user_id UUID,
    p_data_key TEXT,
    p_data JSONB,
    p_expected_version INTEGER,
    p_device_id TEXT DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
    v_current_version INTEGER;
    v_existing_data JSONB;
    v_merged_data JSONB;
    v_new_version INTEGER;
    v_conflict BOOLEAN := false;
BEGIN
    SET search_path = public, pg_temp;
    
    -- Try to get current version and data
    SELECT version, data INTO v_current_version, v_existing_data
    FROM user_sync_data_v2
    WHERE user_id = p_user_id AND data_key = p_data_key
    FOR UPDATE; -- Lock the row
    
    -- If no existing data, insert new
    IF v_current_version IS NULL THEN
        v_new_version := 1;
        
        INSERT INTO user_sync_data_v2 (user_id, data_key, data, version, device_id, modified_at)
        VALUES (p_user_id, p_data_key, p_data, v_new_version, p_device_id, NOW());
        
        RETURN jsonb_build_object(
            'success', true,
            'version', v_new_version,
            'conflict', false,
            'data', p_data,
            'action', 'inserted'
        );
    END IF;
    
    -- Check for version conflict (optimistic locking)
    IF p_expected_version IS NOT NULL AND p_expected_version != v_current_version THEN
        v_conflict := true;
        
        -- Merge data using conflict resolution strategy based on data_key
        CASE p_data_key
            WHEN 'game_stats' THEN
                -- Game stats: max scores, sum incorrect
                v_merged_data := jsonb_build_object(
                    'score', GREATEST(
                        (v_existing_data->>'score')::int, 
                        (p_data->>'score')::int
                    ),
                    'currentStreak', GREATEST(
                        (v_existing_data->>'currentStreak')::int,
                        (p_data->>'currentStreak')::int
                    ),
                    'longestStreak', GREATEST(
                        (v_existing_data->>'longestStreak')::int,
                        (p_data->>'longestStreak')::int
                    ),
                    'incorrectAnswers', COALESCE((v_existing_data->>'incorrectAnswers')::int, 0) + 
                                       COALESCE((p_data->>'incorrectAnswers')::int, 0)
                );
                
            WHEN 'lesson_progress' THEN
                -- Lesson progress: max unlocked, merge stars
                v_merged_data := v_existing_data || p_data;
                -- Ensure unlockedCount is max
                IF (v_existing_data->>'unlockedCount')::int > (p_data->>'unlockedCount')::int THEN
                    v_merged_data := jsonb_set(v_merged_data, '{unlockedCount}', v_existing_data->'unlockedCount');
                END IF;
                -- Merge bestStarsByLesson by taking max
                IF v_existing_data ? 'bestStarsByLesson' AND p_data ? 'bestStarsByLesson' THEN
                    DECLARE
                        v_merged_stars JSONB := v_existing_data->'bestStarsByLesson';
                        v_incoming_stars JSONB := p_data->'bestStarsByLesson';
                        v_lesson_id TEXT;
                        v_incoming_star INT;
                    BEGIN
                        FOR v_lesson_id, v_incoming_star IN 
                            SELECT * FROM jsonb_each_text(v_incoming_stars)
                        LOOP
                            IF (v_merged_stars->>v_lesson_id)::int < v_incoming_star THEN
                                v_merged_stars := jsonb_set(v_merged_stars, array[v_lesson_id], to_jsonb(v_incoming_star));
                            END IF;
                        END LOOP;
                        v_merged_data := jsonb_set(v_merged_data, '{bestStarsByLesson}', v_merged_stars);
                    END;
                END IF;
                
            WHEN 'settings' THEN
                -- Settings: merge AI themes, prefer incoming for other settings
                v_merged_data := p_data;
                IF v_existing_data ? 'aiThemes' AND p_data ? 'aiThemes' THEN
                    -- Merge themes: existing + incoming (incoming overrides)
                    v_merged_data := jsonb_set(
                        v_merged_data, 
                        '{aiThemes}', 
                        (v_existing_data->'aiThemes') || (p_data->'aiThemes')
                    );
                END IF;
                -- Merge unlocked themes (union of both arrays)
                IF v_existing_data ? 'unlockedThemes' AND p_data ? 'unlockedThemes' THEN
                    -- Convert both arrays to text[], concatenate, remove duplicates, and convert back
                    v_merged_data := jsonb_set(
                        v_merged_data,
                        '{unlockedThemes}',
                        (
                            SELECT jsonb_agg(DISTINCT elem ORDER BY elem)
                            FROM (
                                SELECT jsonb_array_elements_text(v_existing_data->'unlockedThemes') AS elem
                                UNION
                                SELECT jsonb_array_elements_text(p_data->'unlockedThemes') AS elem
                            ) combined
                        )
                    );
                END IF;
                
            ELSE
                -- Default: prefer incoming data (last-write-wins)
                v_merged_data := p_data;
        END CASE;
        
        -- Increment version and update with merged data
        v_new_version := v_current_version + 1;
        
        UPDATE user_sync_data_v2
        SET data = v_merged_data,
            version = v_new_version,
            device_id = p_device_id,
            modified_at = NOW()
        WHERE user_id = p_user_id AND data_key = p_data_key;
        
        RETURN jsonb_build_object(
            'success', true,
            'version', v_new_version,
            'conflict', true,
            'data', v_merged_data,
            'action', 'merged'
        );
    END IF;
    
    -- No conflict, proceed with update
    v_new_version := v_current_version + 1;
    
    UPDATE user_sync_data_v2
    SET data = p_data,
        version = v_new_version,
        device_id = p_device_id,
        modified_at = NOW()
    WHERE user_id = p_user_id AND data_key = p_data_key;
    
    RETURN jsonb_build_object(
        'success', true,
        'version', v_new_version,
        'conflict', false,
        'data', p_data,
        'action', 'updated'
    );
    
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'success', false,
        'error', SQLERRM,
        'conflict', false
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Get all sync data for a user with versions
CREATE OR REPLACE FUNCTION get_user_sync_data(p_user_id UUID)
RETURNS TABLE (
    data_key TEXT,
    data JSONB,
    version INTEGER,
    device_id TEXT,
    modified_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    SET search_path = public, pg_temp;
    
    RETURN QUERY
    SELECT 
        s.data_key,
        s.data,
        s.version,
        s.device_id,
        s.modified_at
    FROM user_sync_data_v2 s
    WHERE s.user_id = p_user_id
    ORDER BY s.modified_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Update device sync metadata
CREATE OR REPLACE FUNCTION update_sync_metadata(
    p_user_id UUID,
    p_device_id TEXT,
    p_version INTEGER,
    p_device_info JSONB DEFAULT '{}'
) RETURNS VOID AS $$
BEGIN
    SET search_path = public, pg_temp;
    
    INSERT INTO user_sync_metadata (user_id, device_id, last_sync_at, last_sync_version, device_info)
    VALUES (p_user_id, p_device_id, NOW(), p_version, p_device_info)
    ON CONFLICT (user_id, device_id)
    DO UPDATE SET
        last_sync_at = NOW(),
        last_sync_version = p_version,
        device_info = p_device_info;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Get sync status for all devices
CREATE OR REPLACE FUNCTION get_user_sync_status(p_user_id UUID)
RETURNS TABLE (
    device_id TEXT,
    last_sync_at TIMESTAMP WITH TIME ZONE,
    last_sync_version INTEGER,
    device_info JSONB
) AS $$
BEGIN
    SET search_path = public, pg_temp;
    
    RETURN QUERY
    SELECT 
        m.device_id,
        m.last_sync_at,
        m.last_sync_version,
        m.device_info
    FROM user_sync_metadata m
    WHERE m.user_id = p_user_id
    ORDER BY m.last_sync_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Delete all sync data for a user (for account deletion)
CREATE OR REPLACE FUNCTION delete_user_sync_data(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
    SET search_path = public, pg_temp;
    
    DELETE FROM user_sync_data_v2 WHERE user_id = p_user_id;
    DELETE FROM user_sync_metadata WHERE user_id = p_user_id;
    DELETE FROM user_sync_queue WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Enable Realtime for sync tables
-- ============================================
-- Add tables to realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE user_sync_data_v2;
ALTER PUBLICATION supabase_realtime ADD TABLE user_sync_metadata;

-- ============================================
-- Migration function from old schema to new
-- ============================================
CREATE OR REPLACE FUNCTION migrate_sync_data_v1_to_v2()
RETURNS VOID AS $$
DECLARE
    v_old_record RECORD;
    v_data_key TEXT;
    v_data_entry RECORD;
BEGIN
    SET search_path = public, pg_temp;
    
    -- Migrate data from old user_sync_data table if it exists
    FOR v_old_record IN 
        SELECT user_id, data, updated_at 
        FROM user_sync_data 
        WHERE data IS NOT NULL
    LOOP
        -- Iterate through each key in the old data JSONB
        FOR v_data_entry IN 
            SELECT * FROM jsonb_each(v_old_record.data)
        LOOP
            v_data_key := v_data_entry.key;
            
            -- Insert into new table with version 1
            INSERT INTO user_sync_data_v2 (
                user_id, 
                data_key, 
                data, 
                version, 
                modified_at,
                created_at
            ) VALUES (
                v_old_record.user_id,
                v_data_key,
                COALESCE((v_data_entry.value->>'value')::jsonb, v_data_entry.value),
                1,
                v_old_record.updated_at,
                v_old_record.updated_at
            )
            ON CONFLICT (user_id, data_key) 
            DO UPDATE SET
                data = EXCLUDED.data,
                version = user_sync_data_v2.version + 1,
                modified_at = EXCLUDED.modified_at;
        END LOOP;
    END LOOP;
    
    RAISE NOTICE 'Migration from v1 to v2 completed';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- Triggers for automatic updated_at
-- ============================================
CREATE OR REPLACE FUNCTION update_modified_at_column()
RETURNS TRIGGER AS $$
BEGIN
    SET search_path = public, pg_temp;
    NEW.modified_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for user_sync_data_v2
DROP TRIGGER IF EXISTS update_user_sync_data_v2_modified_at ON user_sync_data_v2;
CREATE TRIGGER update_user_sync_data_v2_modified_at
    BEFORE UPDATE ON user_sync_data_v2
    FOR EACH ROW EXECUTE FUNCTION update_modified_at_column();

-- Create trigger for user_sync_metadata
DROP TRIGGER IF EXISTS update_user_sync_metadata_modified_at ON user_sync_metadata;
CREATE TRIGGER update_user_sync_metadata_modified_at
    BEFORE UPDATE ON user_sync_metadata
    FOR EACH ROW EXECUTE FUNCTION update_modified_at_column();

-- Create trigger for user_sync_queue
DROP TRIGGER IF EXISTS update_user_sync_queue_updated_at ON user_sync_queue;
CREATE TRIGGER update_user_sync_queue_updated_at
    BEFORE UPDATE ON user_sync_queue
    FOR EACH ROW EXECUTE FUNCTION update_modified_at_column();
