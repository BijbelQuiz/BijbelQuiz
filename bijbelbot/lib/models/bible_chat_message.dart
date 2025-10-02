/// Represents the type of message sender in a Bible chat conversation.
enum MessageSender { user, bot }

/// Represents the type of message content in a Bible chat conversation.
enum MessageType { text, bibleReference, explanation, question, greeting }

MessageSender _parseMessageSender(String? sender) {
  if (sender == null) return MessageSender.user;

  switch (sender.toLowerCase()) {
    case 'user':
      return MessageSender.user;
    case 'bot':
      return MessageSender.bot;
    default:
      return MessageSender.user;
  }
}

MessageType _parseMessageType(String? type) {
  if (type == null) return MessageType.text;

  switch (type.toLowerCase()) {
    case 'text':
      return MessageType.text;
    case 'biblereference':
    case 'bible_reference':
      return MessageType.bibleReference;
    case 'explanation':
      return MessageType.explanation;
    case 'question':
      return MessageType.question;
    case 'greeting':
      return MessageType.greeting;
    default:
      return MessageType.text;
  }
}

String _messageSenderToString(MessageSender sender) {
  switch (sender) {
    case MessageSender.user:
      return 'user';
    case MessageSender.bot:
      return 'bot';
  }
}

String _messageTypeToString(MessageType type) {
  switch (type) {
    case MessageType.text:
      return 'text';
    case MessageType.bibleReference:
      return 'bibleReference';
    case MessageType.explanation:
      return 'explanation';
    case MessageType.question:
      return 'question';
    case MessageType.greeting:
      return 'greeting';
  }
}

/// Represents an individual message in a Bible chat conversation.
class BibleChatMessage {
  /// Unique identifier for this message.
  final String id;

  /// The text content of the message.
  final String content;

  /// Timestamp when the message was created.
  final DateTime timestamp;

  /// The sender of this message (user or bot).
  final MessageSender sender;

  /// The type of message content.
  final MessageType type;


  /// Optional Bible references associated with this message.
  final List<String>? bibleReferences;

  /// Optional metadata associated with this message.
  final Map<String, dynamic>? metadata;

  /// Whether this message has been read by the recipient.
  final bool isRead;

  /// Creates a new [BibleChatMessage].
  ///
  /// All parameters except [bibleReferences] and [metadata] are required.
  /// The [timestamp] defaults to the current time if not provided.
  BibleChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.type,
    this.bibleReferences,
    this.metadata,
    this.isRead = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Creates a [BibleChatMessage] from a JSON map.
  ///
  /// This factory is used to parse message data from storage or API responses.
  factory BibleChatMessage.fromJson(Map<String, dynamic> json) {
    final bibleRefs = json['bibleReferences'] != null
        ? (json['bibleReferences'] as List).map((e) => e.toString()).toList()
        : null;

    final meta = json['metadata'] != null
        ? Map<String, dynamic>.from(json['metadata'] as Map)
        : null;

    return BibleChatMessage(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      sender: _parseMessageSender(json['sender']?.toString()),
      type: _parseMessageType(json['type']?.toString()),
      bibleReferences: bibleRefs,
      metadata: meta,
      isRead: json['isRead'] == true,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Converts the [BibleChatMessage] to a JSON map.
  ///
  /// This method is used for storing messages or sending them via API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'sender': _messageSenderToString(sender),
      'type': _messageTypeToString(type),
      'bibleReferences': bibleReferences,
      'metadata': metadata,
      'isRead': isRead,
    };
  }

  /// Creates a copy of this message with the given fields replaced.
  BibleChatMessage copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    MessageSender? sender,
    MessageType? type,
    List<String>? bibleReferences,
    Map<String, dynamic>? metadata,
    bool? isRead,
  }) {
    return BibleChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      bibleReferences: bibleReferences ?? this.bibleReferences,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() => 'BibleChatMessage(id: $id, sender: $sender, type: $type, content: "$content")';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BibleChatMessage &&
        other.id == id &&
        other.content == content &&
        other.timestamp == timestamp &&
        other.sender == sender &&
        other.type == type &&
        other.isRead == isRead;
  }

  @override
  int get hashCode => Object.hash(
        id,
        content,
        timestamp,
        sender,
        type,
        isRead,
      );
}