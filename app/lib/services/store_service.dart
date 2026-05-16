import '../config/supabase_config.dart';
import '../models/store_item.dart';
import '../services/logger.dart';
import '../utils/automatic_error_reporter.dart';

class StoreService {
  static final StoreService _instance = StoreService._internal();
  factory StoreService() => _instance;
  StoreService._internal();

  /// Fetches all store items with their current pricing from Supabase
  Future<List<StoreItem>> getStoreItems() async {
    if (!SupabaseConfig.isInitialized) {
      AppLogger.warning('Store items unavailable: Supabase not initialized');
      return [];
    }

    try {
      final response = await SupabaseConfig.getClient()
          .from('store_items')
          .select()
          .eq('is_active', true)
          .order('category')
          .order('item_name');

      final List<dynamic> rawData = response as List<dynamic>;
      return rawData
          .map((item) => StoreItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching store items from Supabase: $e');

      // Report error to automatic error tracking system
      await AutomaticErrorReporter.reportNetworkError(
        message: 'Failed to fetch store items from Supabase',
        url: 'store_items table',
        additionalInfo: {
          'error': e.toString(),
          'operation': 'get_store_items',
          'is_active_filter': true,
        },
      );

      rethrow;
    }
  }

  /// Fetches a specific store item by its key
  Future<StoreItem?> getStoreItemByKey(String itemKey) async {
    if (!SupabaseConfig.isInitialized) return null;

    try {
      final response = await SupabaseConfig.getClient()
          .from('store_items')
          .select()
          .eq('item_key', itemKey)
          .single();

      return StoreItem.fromJson(response);
    } catch (e) {
      AppLogger.error('Error fetching store item with key $itemKey: $e');

      // Report error to automatic error tracking system
      await AutomaticErrorReporter.reportNetworkError(
        message: 'Failed to fetch store item by key',
        url: 'store_items table',
        additionalInfo: {
          'item_key': itemKey,
          'error': e.toString(),
          'operation': 'get_store_item_by_key',
        },
      );

      return null;
    }
  }

  /// Updates a store item in the database
  Future<bool> updateStoreItem(StoreItem item) async {
    if (!SupabaseConfig.isInitialized) return false;

    try {
      await SupabaseConfig.getClient()
          .from('store_items')
          .update(item.toJson())
          .eq('item_key', item.itemKey)
          .select();

      AppLogger.info('Store item updated successfully: ${item.itemKey}');
      return true;
    } catch (e) {
      AppLogger.error('Error updating store item: $e');

      // Report error to automatic error tracking system
      await AutomaticErrorReporter.reportNetworkError(
        message: 'Failed to update store item',
        url: 'store_items table',
        additionalInfo: {
          'item_key': item.itemKey,
          'error': e.toString(),
          'operation': 'update_store_item',
        },
      );

      return false;
    }
  }

  /// Refreshes the store item cache
  /// This is useful when you want to ensure you have the latest pricing data
  Future<bool> refreshStoreItems() async {
    try {
      // In a real implementation, this might update a local cache
      // For now, we'll just return true to indicate success
      AppLogger.info('Store items refreshed');
      return true;
    } catch (e) {
      AppLogger.error('Error refreshing store items: $e');
      return false;
    }
  }
}
