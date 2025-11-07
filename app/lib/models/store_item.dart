class StoreItem {
  final String itemKey;
  final String itemName;
  final String itemDescription;
  final String itemType;
  final String? icon;
  final int basePrice;
  final int currentPrice;
  final bool isDiscounted;
  final int discountPercentage;
  final bool isActive;
  final String? category;
  final DateTime? discountStart;
  final DateTime? discountEnd;

  StoreItem({
    required this.itemKey,
    required this.itemName,
    required this.itemDescription,
    required this.itemType,
    this.icon,
    required this.basePrice,
    required this.currentPrice,
    required this.isDiscounted,
    required this.discountPercentage,
    required this.isActive,
    this.category,
    this.discountStart,
    this.discountEnd,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      itemKey: json['item_key'] ?? '',
      itemName: json['item_name'] ?? '',
      itemDescription: json['item_description'] ?? '',
      itemType: json['item_type'] ?? '',
      icon: json['icon'],
      basePrice: json['base_price']?.toInt() ?? 0,
      currentPrice: json['current_price']?.toInt() ?? 0,
      isDiscounted: json['is_discounted'] ?? false,
      discountPercentage: json['discount_percentage']?.toInt() ?? 0,
      isActive: json['is_active'] ?? true,
      category: json['category'],
      discountStart: json['discount_start'] != null 
          ? DateTime.parse(json['discount_start']) 
          : null,
      discountEnd: json['discount_end'] != null 
          ? DateTime.parse(json['discount_end']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_key': itemKey,
      'item_name': itemName,
      'item_description': itemDescription,
      'item_type': itemType,
      'icon': icon,
      'base_price': basePrice,
      'current_price': currentPrice,
      'is_discounted': isDiscounted,
      'discount_percentage': discountPercentage,
      'is_active': isActive,
      'category': category,
      'discount_start': discountStart?.toIso8601String(),
      'discount_end': discountEnd?.toIso8601String(),
    };
  }

  /// Calculates the discount amount in stars
  int get discountAmount => basePrice - currentPrice;

  /// Gets the discount percentage as a formatted string
  String get discountPercentageString => '$discountPercentage%';

  /// Checks if the item is currently discounted
  bool get isCurrentlyDiscounted {
    if (!isDiscounted) return false;
    
    // If discount start and end are set, check if we're in the active period
    if (discountStart != null && discountEnd != null) {
      final now = DateTime.now();
      return now.isAfter(discountStart!) && now.isBefore(discountEnd!);
    }
    
    // If no dates are set but discount is active, it's always discounted
    return isDiscounted;
  }
}