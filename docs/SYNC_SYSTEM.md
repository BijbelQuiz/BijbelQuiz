# Multi-Device Data Synchronization System

## Overview

The BijbelQuiz app implements a robust user-based data synchronization system using Supabase as the backend. This system allows authenticated users to seamlessly sync their game progress, statistics, settings, and lesson progress across multiple devices and platforms in real-time.

## Architecture

### Components

1. **SyncService** (`app/lib/services/sync_service.dart`)
   - Core synchronization logic for authenticated users
   - Real-time data updates via Supabase channels
   - Conflict resolution and retry mechanisms
   - Offline queue for failed syncs

2. **GameStatsProvider** (`app/lib/providers/game_stats_provider.dart`)
   - Manages local game statistics
   - Handles sync integration for game data
   - Merges local and remote data on app startup

3. **SettingsProvider** (`app/lib/providers/settings_provider.dart`)
   - Manages user preferences and settings
   - Syncs theme, game speed, mute settings, and AI themes
   - Real-time updates across devices

4. **LessonProgressProvider** (`app/lib/providers/lesson_progress_provider.dart`)
   - Tracks lesson completion and star ratings
   - Syncs progress across user devices
   - Merges best achievements

5. **Database Schema** (`database_supabase/user_sync_data.sql`)
   - JSONB storage for flexible data structures
   - User-scoped data isolation via RLS policies
   - Timestamp tracking for conflict resolution

### Data Flow

```
Device A                     Supabase                     Device B
   |                            |                            |
   |---updateStats()---------->|                            |
   |                            |---real-time update------->|
   |                            |                            |
   |<---sync confirmation-------|<---sync confirmation-------|
   |                            |                            |
```

## Sync Protocols

### Real-Time Synchronization

- Uses Supabase Realtime channels for instant updates
- PostgreSQL change notifications trigger updates
- Automatic reconnection on network issues

### Conflict Resolution

For game statistics, conflicts are resolved by:
- **Score**: Takes the maximum value
- **Streaks**: Takes the maximum value
- **Incorrect Answers**: Sums both values

### Retry Mechanism

- 3 retry attempts with 2-second delays
- Failed syncs are queued for offline processing
- Periodic retry every 5 minutes when online

### Offline Support

- Failed sync operations are stored locally
- Automatic retry when connectivity is restored
- Data integrity validation before sync

## Troubleshooting

### Common Issues

1. **Data not syncing between devices**
   - **Cause**: Real-time listeners not set up (setupSyncListener never called)
   - **Fix**: Ensure setupSyncListener() is called in main.dart for all providers
   - **Check**: Verify "Setting up X sync listener" logs appear on app start

2. **Lost progress after device switch**
   - **Cause**: Initial sync loading not implemented
   - **Fix**: Check that providers load synced data on startup
   - **Check**: Look for "Found synced X" logs on app start

3. **Sync delays or failures**
   - **Cause**: Network issues, retry failures, or data corruption
   - **Fix**: Check retry logs and offline queue processing
   - **Check**: Monitor "Syncing X" and "Successfully synced" logs

4. **Settings not syncing**
   - **Cause**: Only theme changes triggered sync initially
   - **Fix**: All settings changes now trigger sync
   - **Check**: Verify _syncSettings() calls in setting methods

5. **Lesson progress not syncing**
   - **Cause**: No initial load from sync + no real-time listener
   - **Fix**: Added both initial loading and real-time updates
   - **Check**: Look for lesson progress merge logs on startup

### Recovery Procedures

1. **Force sync refresh**
   - Use manual sync button in account screen
   - Restart app to trigger initial sync load
   - Check offline queue processing logs

2. **Clear local data**
   - Reset local SharedPreferences (clear app data)
   - Allow sync to repopulate from server on next login

3. **Manual data recovery**
   - Use Supabase dashboard to inspect user_sync_data table
   - Manually update corrupted records if needed
   - Check data integrity validation logs

4. **Debug sync issues**
   - Enable detailed logging
   - Check for "Sync listener setup" messages on startup
   - Verify real-time update messages between devices

## End-User Guide

### Understanding Sync Behavior

- **Automatic Sync**: Game progress syncs automatically when playing
- **Cross-Device Access**: Your stats are available on all your devices
- **Offline Play**: Play without internet, sync when connected
- **Conflict Resolution**: Best scores and streaks are preserved

### Best Practices

1. **Stay Connected**: Sync works best with stable internet
2. **Regular Play**: Frequent play ensures up-to-date sync
3. **Device Consistency**: Use the same account across devices

### Troubleshooting for Users

- **"My progress disappeared"**: Restart the app to reload synced data
- **"Scores not updating"**: Check internet connection and try again
- **"Different scores on devices"**: The system keeps the highest scores

## Technical Implementation Details

### Database Schema

```sql
CREATE TABLE user_sync_data (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id),
    data JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Sync Data Structure

```json
{
  "game_stats": {
    "value": {
      "score": 150,
      "currentStreak": 5,
      "longestStreak": 12,
      "incorrectAnswers": 3
    },
    "timestamp": "2025-11-20T10:00:00.000Z"
  },
  "settings": {
    "value": {
      "themeMode": 0,
      "gameSpeed": "medium",
      "mute": false,
      "layoutType": "grid",
      "colorfulMode": false,
      "aiThemes": {...}
    },
    "timestamp": "2025-11-20T10:00:00.000Z"
  },
  "lesson_progress": {
    "value": {
      "unlockedCount": 5,
      "bestStarsByLesson": {
        "lesson1": 3,
        "lesson2": 2
      }
    },
    "timestamp": "2025-11-20T10:00:00.000Z"
  }
}
```

### Error Handling

- Network failures trigger retry with exponential backoff
- Data corruption is detected and rejected
- Auth failures pause sync until re-authentication

## Testing

### Unit Tests

- SyncService retry logic
- Conflict resolution algorithms
- Data validation functions

### Integration Tests

- Multi-device sync scenarios
- Offline/online transitions
- Network failure recovery

### Manual Testing Checklist

- [ ] Sync between Android and iOS devices
- [ ] Offline play then sync on reconnection
- [ ] Concurrent updates from multiple devices
- [ ] Network interruption during sync
- [ ] App restart data loading

## Critical Issues Fixed

### Real-Time Sync Listeners Not Initialized
**Issue**: `setupSyncListener()` methods were defined but never called, preventing automatic sync between devices.

**Impact**: Devices would never receive real-time updates from other devices, making sync manual-only.

**Fix**: Added `setupSyncListener()` calls in `main.dart` for all providers:
```dart
gameStatsProvider.setupSyncListener();
settingsProvider.setupSyncListener();
lessonProgressProvider.setupSyncListener();
```

**Verification**: Check for "Setting up X sync listener" logs on app startup.

### Incomplete Settings Sync
**Issue**: Only theme mode changes triggered sync; other settings changes were ignored.

**Impact**: User preferences wouldn't sync between devices.

**Fix**: Added `_syncSettings()` calls to all major settings methods.

**Verification**: All settings changes now show "Syncing settings after change" logs.

### Missing Lesson Progress Initial Load
**Issue**: Lesson progress only synced on completion, never loaded from server on app start.

**Impact**: Users would lose lesson progress when switching devices.

**Fix**: Added initial sync data loading and merging in `LessonProgressProvider._load()`.

**Verification**: Check for "Found synced lesson progress" logs on startup.

## Future Improvements

1. **Advanced Conflict Resolution**
   - User choice for conflicting data
   - Timestamp-based last-write-wins for all data types

2. **Enhanced Offline Support**
   - Full offline queue with proper serialization
   - Conflict resolution for queued items

3. **Performance Optimizations**
   - Delta syncing for large datasets
   - Compression for network efficiency

4. **Monitoring and Analytics**
   - Sync success/failure metrics
   - Performance monitoring
   - User experience tracking