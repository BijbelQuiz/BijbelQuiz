import '../models/store_item.dart';
import '../services/store_service.dart';

/// Helper class to get dynamic prices for quiz actions from the store database
class QuizActionPriceHelper {
  static final QuizActionPriceHelper _instance =
      QuizActionPriceHelper._internal();
  factory QuizActionPriceHelper() => _instance;
  QuizActionPriceHelper._internal();

  List<StoreItem>? _cachedStoreItems;
  DateTime? _lastCacheTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Get price for skipping a question
  Future<int> getSkipQuestionPrice() async {
    return await _getPriceForItem('skip_question', defaultPrice: 35);
  }

  /// Get price for unlocking biblical reference
  Future<int> getUnlockBiblicalReferencePrice() async {
    return await _getPriceForItem('unlock_biblical_reference',
        defaultPrice: 10);
  }

  /// Internal method to get price for an item with caching
  Future<int> _getPriceForItem(String itemKey,
      {required int defaultPrice}) async {
    try {
      // Check if we need to refresh cache
      if (_cachedStoreItems == null || _shouldRefreshCache()) {
        final storeService = StoreService();
        _cachedStoreItems = await storeService.getStoreItems();
        _lastCacheTime = DateTime.now();
      }

      // Find the item
      final item = _cachedStoreItems?.firstWhere(
        (item) => item.itemKey == itemKey,
        orElse: () => StoreItem(
          itemKey: itemKey,
          itemName: '',
          itemDescription: '',
          itemType: '',
          basePrice: defaultPrice,
          currentPrice: defaultPrice,
          isDiscounted: false,
          discountPercentage: 0,
          isActive: true,
          discountStart: null,
          discountEnd: null,
        ),
      );

      return item?.currentPrice ?? defaultPrice;
    } catch (e) {
      // Return default price if loading fails
      return defaultPrice;
    }
  }

  /// Check if cache should be refreshed
  bool _shouldRefreshCache() {
    if (_lastCacheTime == null) return true;
    return DateTime.now().difference(_lastCacheTime!) > _cacheDuration;
  }

  /// Clear the cache (useful for testing or when prices change)
  void clearCache() {
    _cachedStoreItems = null;
    _lastCacheTime = null;
  }

  /// Force refresh the cache
  Future<void> refreshCache() async {
    try {
      final storeService = StoreService();
      _cachedStoreItems = await storeService.getStoreItems();
      _lastCacheTime = DateTime.now();
    } catch (e) {
      // If refresh fails, keep existing cache
    }
  }
}
