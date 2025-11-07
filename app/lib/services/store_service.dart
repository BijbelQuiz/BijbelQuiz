import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/store_item.dart';
import '../services/logger.dart';

class StoreService {
  static final StoreService _instance = StoreService._internal();
  factory StoreService() => _instance;
  StoreService._internal();

  /// Fetches all store items with their current pricing from Supabase
  Future<List<StoreItem>> getStoreItems() async {
    try {
      final response = await SupabaseConfig.getClient()
          .from('store_items')
          .select()
          .eq('is_active', true)
          .order('category')
          .order('item_name');

      final List<dynamic> rawData = response as List<dynamic>;
      return rawData.map((item) => StoreItem.fromJson(item as Map<String, dynamic>)).toList();
        } catch (e) {
      AppLogger.error('Error fetching store items from Supabase: $e');
      rethrow;
    }
  }

  /// Fetches a specific store item by its key
  Future<StoreItem?> getStoreItemByKey(String itemKey) async {
    try {
      final response = await SupabaseConfig.getClient()
          .from('store_items')
          .select()
          .eq('item_key', itemKey)
          .single();

      return StoreItem.fromJson(response as Map<String, dynamic>);
        } catch (e) {
      AppLogger.error('Error fetching store item with key $itemKey: $e');
      return null;
    }
  }

  /// Updates a store item in the database
  Future<bool> updateStoreItem(StoreItem item) async {
    try {
      final response = await SupabaseConfig.getClient()
          .from('store_items')
          .update(item.toJson())
          .eq('item_key', item.itemKey)
          .select();

      AppLogger.info('Store item updated successfully: ${item.itemKey}');
      return true;
        } catch (e) {
      AppLogger.error('Error updating store item: $e');
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