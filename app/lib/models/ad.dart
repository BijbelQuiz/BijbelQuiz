
/// Model representing an advertisement in the database
class Ad {
  final String id;
  final String title;
  final String text;
  final String? linkUrl;
  final bool isActive;
  final DateTime startDate;
  final DateTime expiryDate;
  final DateTime createdAt;

  const Ad({
    required this.id,
    required this.title,
    required this.text,
    this.linkUrl,
    required this.isActive,
    required this.startDate,
    required this.expiryDate,
    required this.createdAt,
  });

  /// Create an Ad from a Supabase row
  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      linkUrl: json['link_url'] as String?,
      isActive: json['is_active'] as bool,
      startDate: DateTime.parse(json['start_date'] as String),
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert Ad to JSON for database operations
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'link_url': linkUrl,
      'is_active': isActive,
      'start_date': startDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if the ad is currently valid based on date range
  bool get isCurrentlyValid {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(startDate) && 
           now.isBefore(expiryDate);
  }

  @override
  String toString() {
    return 'Ad(id: $id, title: $title, isActive: $isActive, valid: $isCurrentlyValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ad && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}