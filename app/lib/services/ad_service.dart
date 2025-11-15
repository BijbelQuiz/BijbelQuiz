import 'dart:math';
import '../config/supabase_config.dart';
import '../models/ad.dart';
import '../services/logger.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  /// Fetches a random active ad that's currently valid
  /// Returns null if no valid ads are available or offline
  Future<Ad?> getRandomAd() async {
    try {
      final now = DateTime.now().toIso8601String();

      final response = await SupabaseConfig.getClient()
          .from('ads')
          .select()
          .eq('is_active', true)
          .lte('start_date', now)
          .gte('expiry_date', now)
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        AppLogger.info('No valid ads found in database');
        return null;
      }

      // Convert to Ad objects
      final ads = response.map((item) => Ad.fromJson(item)).toList();

      // Pick a random ad
      final random = Random();
      final selectedAd = ads[random.nextInt(ads.length)];

      AppLogger.info('Selected random ad: ${selectedAd.title}');
      return selectedAd;
    } catch (e) {
      AppLogger.warning(
          'Error fetching random ad from Supabase (offline or database error): $e');
      return null;
    }
  }

  /// Fetches all active ads (for admin purposes)
  /// Returns empty list if database is empty or offline
  Future<List<Ad>> getAllActiveAds() async {
    try {
      final response = await SupabaseConfig.getClient()
          .from('ads')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      if ((response as List<dynamic>).isEmpty) {
        AppLogger.info('No ads in database');
        return [];
      }

      return (response as List<dynamic>)
          .map((item) => Ad.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.warning(
          'Error fetching all active ads from Supabase (offline or database error): $e');
      return [];
    }
  }

  /// Fetches a specific ad by ID
  /// Returns null if not found or offline
  Future<Ad?> getAdById(String adId) async {
    try {
      final response = await SupabaseConfig.getClient()
          .from('ads')
          .select()
          .eq('id', adId)
          .single();

      return Ad.fromJson(response);
    } catch (e) {
      AppLogger.warning(
          'Error fetching ad with ID $adId (offline or not found): $e');
      return null;
    }
  }

  /// Creates a new ad in the database
  Future<Ad?> createAd(Ad ad) async {
    try {
      final response = await SupabaseConfig.getClient()
          .from('ads')
          .insert(ad.toJson())
          .select()
          .single();

      final createdAd = Ad.fromJson(response);
      AppLogger.info('Ad created successfully: ${createdAd.id}');
      return createdAd;
    } catch (e) {
      AppLogger.error('Error creating ad: $e');
      return null;
    }
  }

  /// Updates an existing ad
  Future<bool> updateAd(Ad ad) async {
    try {
      await SupabaseConfig.getClient()
          .from('ads')
          .update(ad.toJson())
          .eq('id', ad.id);

      AppLogger.info('Ad updated successfully: ${ad.id}');
      return true;
    } catch (e) {
      AppLogger.error('Error updating ad ${ad.id}: $e');
      return false;
    }
  }

  /// Gets a display-ready ad
  /// Returns null if no valid ads are available
  Future<Ad?> getDisplayAd() async {
    final ad = await getRandomAd();

    // Additional validation to ensure the ad is non-intrusive and valid
    if (ad == null || !ad.isCurrentlyValid) {
      AppLogger.info('No valid ads available for display');
      return null;
    }

    return ad;
  }

  /// Preloads ads into memory for faster display
  /// This can be called during app initialization
  static List<Ad> _adCache = [];

  static Future<void> preloadAds() async {
    final adService = AdService();
    final cachedAds = await adService.getAllActiveAds();
    _adCache = cachedAds;
    AppLogger.info('Preloaded ${_adCache.length} ads into cache');
  }

  /// Gets a random ad from the preloaded cache
  /// Returns null if cache is empty
  static Ad? getCachedAd() {
    if (_adCache.isEmpty) {
      AppLogger.info('No ads in cache');
      return null;
    }

    final random = Random();
    return _adCache[random.nextInt(_adCache.length)];
  }

  /// Refreshes the ad cache
  static Future<void> refreshAdCache() async {
    await preloadAds();
  }

  /// Check if we're likely offline by testing database connectivity
  Future<bool> isOnline() async {
    try {
      // Simple query to test connectivity
      await SupabaseConfig.getClient().from('ads').select('id').limit(1);
      return true;
    } catch (e) {
      AppLogger.warning(
          'Database connectivity test failed, likely offline: $e');
      return false;
    }
  }

  /// Gets ad statistics for debugging
  Map<String, dynamic> getAdStats() {
    return {
      'cacheSize': _adCache.length,
      'databaseAvailable': _adCache.isNotEmpty,
    };
  }
}
