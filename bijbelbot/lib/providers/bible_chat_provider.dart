import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/bible_chat_message.dart';
import '../models/bible_chat_conversation.dart';
import '../services/logger.dart';

/// Provider for managing Bible chat conversations and messages
class BibleChatProvider extends ChangeNotifier {
  static const String _conversationsKey = 'bible_chat_conversations';
  static const String _messagesKey = 'bible_chat_messages';
  static const String _activeConversationKey = 'bible_chat_active_conversation';

  SharedPreferences? _prefs;

  // In-memory storage for quick access
  final Map<String, BibleChatConversation> _conversations = {};
  final Map<String, BibleChatMessage> _messages = {};
  String? _activeConversationId;

  bool _isLoading = true;
  String? _error;

  BibleChatProvider() {
    AppLogger.info('BibleChatProvider initializing...');
    _loadChatData();
  }

  /// Whether chat data is currently being loaded
  bool get isLoading => _isLoading;

  /// Any error that occurred while loading or saving chat data
  String? get error => _error;

  /// List of all conversations
  List<BibleChatConversation> get conversations => _conversations.values.toList();

  /// List of active conversations only
  List<BibleChatConversation> get activeConversations =>
      _conversations.values.where((conv) => conv.isActive).toList();

  /// The currently active conversation
  BibleChatConversation? get activeConversation =>
      _activeConversationId != null ? _conversations[_activeConversationId] : null;

  /// Gets a conversation by ID
  BibleChatConversation? getConversation(String conversationId) =>
      _conversations[conversationId];

  /// Gets messages for a specific conversation
  List<BibleChatMessage> getConversationMessages(String conversationId) {
    final conversation = _conversations[conversationId];
    if (conversation == null) return [];

    return conversation.messageIds
        .map((messageId) => _messages[messageId])
        .where((message) => message != null)
        .cast<BibleChatMessage>()
        .toList();
  }

  /// Gets a message by ID
  BibleChatMessage? getMessage(String messageId) => _messages[messageId];

  /// Creates a new conversation
  Future<BibleChatConversation> createConversation({
    String? title,
    Map<String, dynamic>? userContext,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final conversation = BibleChatConversation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startTime: DateTime.now(),
        messageIds: [],
        title: title,
        userContext: userContext,
        metadata: metadata,
      );

      await _saveConversation(conversation);
      AppLogger.info('Created new conversation: ${conversation.id}');

      return conversation;
    } catch (e) {
      _error = 'Failed to create conversation: ${e.toString()}';
      AppLogger.error(_error!, e);
      notifyListeners();
      rethrow;
    }
  }

  /// Adds a message to a conversation
  Future<BibleChatMessage> addMessage({
    required String conversationId,
    required String content,
    required MessageSender sender,
    required MessageType type,
    List<String>? bibleReferences,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final message = BibleChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        sender: sender,
        type: type,
        bibleReferences: bibleReferences,
        metadata: metadata,
      );

      await _saveMessage(message);

      // Update conversation with new message
      final conversation = _conversations[conversationId];
      if (conversation != null) {
        final updatedConversation = conversation.withNewMessage(message.id);
        await _saveConversation(updatedConversation);
      }

      AppLogger.info('Added message ${message.id} to conversation $conversationId');
      return message;
    } catch (e) {
      _error = 'Failed to add message: ${e.toString()}';
      AppLogger.error(_error!, e);
      notifyListeners();
      rethrow;
    }
  }

  /// Updates an existing conversation
  Future<void> updateConversation(BibleChatConversation conversation) async {
    try {
      await _saveConversation(conversation);
      AppLogger.info('Updated conversation: ${conversation.id}');
    } catch (e) {
      _error = 'Failed to update conversation: ${e.toString()}';
      AppLogger.error(_error!, e);
      notifyListeners();
      rethrow;
    }
  }

  /// Deletes a conversation and all its messages
  Future<void> deleteConversation(String conversationId) async {
    try {
      final conversation = _conversations[conversationId];
      if (conversation == null) return;

      // Remove all messages in this conversation
      for (final messageId in conversation.messageIds) {
        _messages.remove(messageId);
      }

      // Remove conversation
      _conversations.remove(conversationId);

      // Clear active conversation if it was deleted
      if (_activeConversationId == conversationId) {
        _activeConversationId = null;
        await _prefs?.remove(_activeConversationKey);
      }

      await _saveAllConversations();
      await _saveAllMessages();

      AppLogger.info('Deleted conversation: $conversationId');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete conversation: ${e.toString()}';
      AppLogger.error(_error!, e);
      notifyListeners();
      rethrow;
    }
  }

  /// Sets the active conversation
  Future<void> setActiveConversation(String? conversationId) async {
    try {
      _activeConversationId = conversationId;
      if (conversationId != null) {
        await _prefs?.setString(_activeConversationKey, conversationId);
      } else {
        await _prefs?.remove(_activeConversationKey);
      }

      AppLogger.info('Set active conversation: $conversationId');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to set active conversation: ${e.toString()}';
      AppLogger.error(_error!, e);
      notifyListeners();
      rethrow;
    }
  }

  /// Marks a message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      final message = _messages[messageId];
      if (message != null && !message.isRead) {
        final updatedMessage = message.copyWith(isRead: true);
        await _saveMessage(updatedMessage);
      }
    } catch (e) {
      AppLogger.error('Failed to mark message as read: $messageId', e);
      // Don't throw here as this is not critical
    }
  }

  /// Gets conversation statistics
  Map<String, dynamic> getConversationStats() {
    final totalConversations = _conversations.length;
    final activeConversations = _conversations.values.where((c) => c.isActive).length;
    final totalMessages = _messages.length;

    return {
      'totalConversations': totalConversations,
      'activeConversations': activeConversations,
      'totalMessages': totalMessages,
    };
  }

  /// Exports all chat data for backup
  Map<String, dynamic> exportChatData() {
    return {
      'conversations': _conversations.map((key, value) => MapEntry(key, value.toJson())),
      'messages': _messages.map((key, value) => MapEntry(key, value.toJson())),
      'activeConversationId': _activeConversationId,
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Imports chat data from backup
  Future<void> importChatData(Map<String, dynamic> data) async {
    try {
      _conversations.clear();
      _messages.clear();

      // Import conversations
      final conversationsData = data['conversations'] as Map<String, dynamic>? ?? {};
      for (final entry in conversationsData.entries) {
        final conversation = BibleChatConversation.fromJson(entry.value as Map<String, dynamic>);
        _conversations[entry.key] = conversation;
      }

      // Import messages
      final messagesData = data['messages'] as Map<String, dynamic>? ?? {};
      for (final entry in messagesData.entries) {
        final message = BibleChatMessage.fromJson(entry.value as Map<String, dynamic>);
        _messages[entry.key] = message;
      }

      // Set active conversation
      _activeConversationId = data['activeConversationId']?.toString();

      await _saveAllConversations();
      await _saveAllMessages();
      if (_activeConversationId != null) {
        await _prefs?.setString(_activeConversationKey, _activeConversationId!);
      }

      AppLogger.info('Imported chat data: ${_conversations.length} conversations, ${_messages.length} messages');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to import chat data: ${e.toString()}';
      AppLogger.error(_error!, e);
      notifyListeners();
      rethrow;
    }
  }

  /// Clears all chat data
  Future<void> clearAllData() async {
    try {
      _conversations.clear();
      _messages.clear();
      _activeConversationId = null;

      await _prefs?.remove(_conversationsKey);
      await _prefs?.remove(_messagesKey);
      await _prefs?.remove(_activeConversationKey);

      AppLogger.info('Cleared all chat data');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear chat data: ${e.toString()}';
      AppLogger.error(_error!, e);
      notifyListeners();
      rethrow;
    }
  }

  /// Loads all chat data from persistent storage
  Future<void> _loadChatData() async {
    try {
      AppLogger.info('Loading chat data from persistent storage...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      _prefs = await SharedPreferences.getInstance();
      AppLogger.info('SharedPreferences instance obtained');

      // Load conversations
      await _loadConversations();

      // Load messages
      await _loadMessages();

      // Load active conversation
      _activeConversationId = _prefs?.getString(_activeConversationKey);

      AppLogger.info('Chat data loaded: ${_conversations.length} conversations, ${_messages.length} messages');
    } catch (e) {
      _error = 'Failed to load chat data: ${e.toString()}';
      AppLogger.error(_error!, e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads conversations from storage
  Future<void> _loadConversations() async {
    try {
      final conversationsJson = _prefs?.getString(_conversationsKey);
      if (conversationsJson != null && conversationsJson.isNotEmpty) {
        final conversationsData = json.decode(conversationsJson) as Map<String, dynamic>;

        _conversations.clear();
        for (final entry in conversationsData.entries) {
          final conversation = BibleChatConversation.fromJson(entry.value as Map<String, dynamic>);
          _conversations[entry.key] = conversation;
        }

        AppLogger.info('Loaded ${_conversations.length} conversations');
      }
    } catch (e) {
      AppLogger.error('Failed to load conversations: $e');
      _conversations.clear();
    }
  }

  /// Loads messages from storage
  Future<void> _loadMessages() async {
    try {
      final messagesJson = _prefs?.getString(_messagesKey);
      if (messagesJson != null && messagesJson.isNotEmpty) {
        final messagesData = json.decode(messagesJson) as Map<String, dynamic>;

        _messages.clear();
        for (final entry in messagesData.entries) {
          final message = BibleChatMessage.fromJson(entry.value as Map<String, dynamic>);
          _messages[entry.key] = message;
        }

        AppLogger.info('Loaded ${_messages.length} messages');
      }
    } catch (e) {
      AppLogger.error('Failed to load messages: $e');
      _messages.clear();
    }
  }

  /// Saves a conversation to storage
  Future<void> _saveConversation(BibleChatConversation conversation) async {
    _conversations[conversation.id] = conversation;
    await _saveAllConversations();
  }

  /// Saves all conversations to storage
  Future<void> _saveAllConversations() async {
    try {
      final conversationsData = _conversations.map((key, value) => MapEntry(key, value.toJson()));
      final jsonString = json.encode(conversationsData);
      await _prefs?.setString(_conversationsKey, jsonString);
    } catch (e) {
      AppLogger.error('Failed to save conversations: $e');
      throw Exception('Failed to save conversations');
    }
  }

  /// Saves a message to storage
  Future<void> _saveMessage(BibleChatMessage message) async {
    _messages[message.id] = message;
    await _saveAllMessages();
  }

  /// Saves all messages to storage
  Future<void> _saveAllMessages() async {
    try {
      final messagesData = _messages.map((key, value) => MapEntry(key, value.toJson()));
      final jsonString = json.encode(messagesData);
      await _prefs?.setString(_messagesKey, jsonString);
    } catch (e) {
      AppLogger.error('Failed to save messages: $e');
      throw Exception('Failed to save messages');
    }
  }
}