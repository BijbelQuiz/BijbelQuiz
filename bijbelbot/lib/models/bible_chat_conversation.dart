/// Represents a Bible chat conversation between a user and the Bible bot.
class BibleChatConversation {
  /// Unique identifier for this conversation.
  final String id;

  /// Timestamp when the conversation was started.
  final DateTime startTime;

  /// Timestamp of the last activity in this conversation.
  final DateTime lastActivity;

  /// List of messages in this conversation, ordered chronologically.
  final List<String> messageIds;

  /// Maximum number of messages to keep in history.
  final int maxHistoryLimit;


  /// User's context or preferences for this conversation.
  final Map<String, dynamic>? userContext;

  /// Metadata associated with this conversation.
  final Map<String, dynamic>? metadata;

  /// Whether this conversation is currently active.
  final bool isActive;

  /// Title or summary of the conversation (optional).
  final String? title;

  /// Creates a new [BibleChatConversation].
  ///
  /// The [messageIds] parameter specifies which messages belong to this conversation.
  /// The [maxHistoryLimit] defaults to 100 if not provided.
  const BibleChatConversation({
    required this.id,
    required this.startTime,
    required this.messageIds,
    this.maxHistoryLimit = 100,
    this.userContext,
    this.metadata,
    this.isActive = true,
    this.title,
    DateTime? lastActivity,
  }) : lastActivity = lastActivity ?? startTime;

  /// Creates a [BibleChatConversation] from a JSON map.
  ///
  /// This factory is used to parse conversation data from storage or API responses.
  factory BibleChatConversation.fromJson(Map<String, dynamic> json) {
    final context = json['userContext'] != null
        ? Map<String, dynamic>.from(json['userContext'] as Map)
        : null;

    final meta = json['metadata'] != null
        ? Map<String, dynamic>.from(json['metadata'] as Map)
        : null;

    final messages = json['messageIds'] != null
        ? (json['messageIds'] as List).map((e) => e.toString()).toList()
        : <String>[];

    return BibleChatConversation(
      id: json['id']?.toString() ?? '',
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lastActivity: json['lastActivity'] != null
          ? DateTime.tryParse(json['lastActivity'].toString()) ?? DateTime.now()
          : DateTime.now(),
      messageIds: messages,
      maxHistoryLimit: (json['maxHistoryLimit'] is int)
          ? json['maxHistoryLimit'] as int
          : int.tryParse(json['maxHistoryLimit']?.toString() ?? '') ?? 100,
      userContext: context,
      metadata: meta,
      isActive: json['isActive'] != false,
      title: json['title']?.toString(),
    );
  }

  /// Converts the [BibleChatConversation] to a JSON map.
  ///
  /// This method is used for storing conversations or sending them via API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
      'messageIds': messageIds,
      'maxHistoryLimit': maxHistoryLimit,
      'userContext': userContext,
      'metadata': metadata,
      'isActive': isActive,
      'title': title,
    };
  }

  /// Creates a copy of this conversation with the given fields replaced.
  BibleChatConversation copyWith({
    String? id,
    DateTime? startTime,
    DateTime? lastActivity,
    List<String>? messageIds,
    int? maxHistoryLimit,
    Map<String, dynamic>? userContext,
    Map<String, dynamic>? metadata,
    bool? isActive,
    String? title,
  }) {
    return BibleChatConversation(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      lastActivity: lastActivity ?? this.lastActivity,
      messageIds: messageIds ?? this.messageIds,
      maxHistoryLimit: maxHistoryLimit ?? this.maxHistoryLimit,
      userContext: userContext ?? this.userContext,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      title: title ?? this.title,
    );
  }

  /// Creates a new conversation with updated last activity and adds a message ID.
  BibleChatConversation withNewMessage(String messageId) {
    final updatedMessageIds = _addMessageId(messageId);
    return copyWith(
      messageIds: updatedMessageIds,
      lastActivity: DateTime.now(),
    );
  }

  /// Creates a new conversation with updated last activity (no new message).
  BibleChatConversation withUpdatedActivity() {
    return copyWith(lastActivity: DateTime.now());
  }

  /// Adds a message ID to the conversation, respecting the history limit.
  List<String> _addMessageId(String messageId) {
    final List<String> updated = List.from(messageIds);
    updated.add(messageId);

    // Trim to history limit if exceeded
    if (updated.length > maxHistoryLimit) {
      return updated.sublist(updated.length - maxHistoryLimit);
    }

    return updated;
  }

  /// Gets the number of messages in this conversation.
  int get messageCount => messageIds.length;

  /// Checks if the conversation has reached its history limit.
  bool get isAtHistoryLimit => messageIds.length >= maxHistoryLimit;

  /// Gets the duration of this conversation.
  Duration get duration => lastActivity.difference(startTime);

  @override
  String toString() => 'BibleChatConversation(id: $id, messages: $messageCount, active: $isActive)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BibleChatConversation &&
        other.id == id &&
        other.startTime == startTime &&
        other.lastActivity == lastActivity &&
        other.messageIds.length == messageIds.length &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(
        id,
        startTime,
        lastActivity,
        messageIds.length,
        isActive,
      );
}