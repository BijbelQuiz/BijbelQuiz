import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../services/logger.dart';

/// Manages user profiles, including CRUD operations and active profile selection.
class ProfileProvider extends ChangeNotifier {
  static const String _profilesKey = 'user_profiles';
  static const String _activeProfileKey = 'active_profile_id';

  SharedPreferences? _prefs;
  List<UserProfile> _profiles = [];
  UserProfile? _activeProfile;

  bool _isLoading = true;
  String? _error;

  /// A list of all user profiles.
  List<UserProfile> get profiles => _profiles;

  /// The currently active user profile.
  UserProfile? get activeProfile => _activeProfile;

  /// Whether the provider is currently loading data.
  bool get isLoading => _isLoading;

  /// An error message, if any occurred.
  String? get error => _error;

  /// Initializes the provider by loading profiles from storage.
  ProfileProvider() {
    _loadProfiles();
  }

  /// Loads profiles and the active profile from SharedPreferences.
  Future<void> _loadProfiles() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _prefs = await SharedPreferences.getInstance();
      final profilesJson = _prefs?.getStringList(_profilesKey) ?? [];
      _profiles = profilesJson
          .map((json) => UserProfile.fromJsonString(json))
          .toList();

      final activeProfileId = _prefs?.getString(_activeProfileKey);
      if (activeProfileId != null) {
        try {
          _activeProfile = _profiles.firstWhere((p) => p.id == activeProfileId);
        } catch (e) {
          _activeProfile = _profiles.isNotEmpty ? _profiles.first : null;
        }
      } else if (_profiles.isNotEmpty) {
        _activeProfile = _profiles.first;
      }

      if (_profiles.isEmpty) {
        final oldScoreKey = 'game_score';
        if (_prefs!.containsKey(oldScoreKey)) {
          final defaultProfile = UserProfile(name: 'Hoofdprofiel');
          _profiles.add(defaultProfile);
          _activeProfile = defaultProfile;
          await _saveProfiles();
          await _prefs!.setString(_activeProfileKey, defaultProfile.id);
          AppLogger.info('Migrated old data to a new default profile.');
        }
      }

      AppLogger.info('Loaded ${_profiles.length} profiles. Active profile: ${_activeProfile?.name}');
    } catch (e) {
      _error = 'Failed to load profiles: $e';
      AppLogger.error(_error!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves the list of profiles to SharedPreferences.
  Future<void> _saveProfiles() async {
    try {
      final profilesJson =
          _profiles.map((p) => p.toJsonString()).toList();
      await _prefs?.setStringList(_profilesKey, profilesJson);
    } catch (e) {
      _error = 'Failed to save profiles: $e';
      AppLogger.error(_error!);
      notifyListeners();
    }
  }

  /// Adds a new user profile.
  Future<void> addProfile(UserProfile profile) async {
    _profiles.add(profile);
    await _saveProfiles();
    notifyListeners();
     AppLogger.info('Added profile: ${profile.name}');
  }

  /// Updates an existing user profile.
  Future<void> updateProfile(UserProfile profile) async {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
      await _saveProfiles();
      if (_activeProfile?.id == profile.id) {
        _activeProfile = profile;
      }
      notifyListeners();
      AppLogger.info('Updated profile: ${profile.name}');
    }
  }

  /// Deletes a user profile.
  Future<void> deleteProfile(String profileId) async {
    _profiles.removeWhere((p) => p.id == profileId);
    if (_activeProfile?.id == profileId) {
      _activeProfile = _profiles.isNotEmpty ? _profiles.first : null;
      await _prefs?.setString(_activeProfileKey, _activeProfile?.id ?? '');
    }
    await _saveProfiles();
    notifyListeners();
    AppLogger.info('Deleted profile: $profileId');
  }

  /// Sets the active user profile.
  Future<void> setActiveProfile(String profileId) async {
    final profile = _profiles.firstWhere((p) => p.id == profileId);
    _activeProfile = profile;
    await _prefs?.setString(_activeProfileKey, profileId);
    notifyListeners();
     AppLogger.info('Set active profile: ${profile.name}');
  }
}
