import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/messaging_service.dart';

/// Provider for managing message state and unread message tracking
class MessagesProvider with ChangeNotifier {
  final MessagingService _messagingService;

  List<Message> _activeMessages = [];
  Set<String> _viewedMessageIds = {};
  bool _isLoading = false;
  String? _errorMessage;
  int _unreadCount = 0;
  SharedPreferences? _prefs;
  static const String _viewedMessagesKey = 'viewed_message_ids';

  MessagesProvider(this._messagingService);

  /// Getters
  List<Message> get activeMessages => List.unmodifiable(_activeMessages);
  Set<String> get viewedMessageIds => Set.unmodifiable(_viewedMessageIds);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount;
  bool get hasUnreadMessages => _unreadCount > 0;

  /// Initializes the provider and loads persisted data
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadViewedMessageIds();
  }

  /// Loads viewed message IDs from persistent storage
  Future<void> _loadViewedMessageIds() async {
    if (_prefs == null) return;

    final messageIdsString = _prefs!.getStringList(_viewedMessagesKey);
    if (messageIdsString != null) {
      _viewedMessageIds = messageIdsString.toSet();
    }
  }

  /// Saves viewed message IDs to persistent storage
  Future<void> _saveViewedMessageIds() async {
    if (_prefs == null) return;

    final messageIdsList = _viewedMessageIds.toList();
    await _prefs!.setStringList(_viewedMessagesKey, messageIdsList);
  }

  /// Loads active messages and tracks which ones have been viewed
  Future<void> loadActiveMessages() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final messages = await _messagingService.getActiveMessages();

      // Update messages
      _activeMessages = messages;

      // Calculate unread count
      _calculateUnreadCount();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load messages: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Calculates the number of unread messages
  void _calculateUnreadCount() {
    _unreadCount = _activeMessages
        .where((message) => !_viewedMessageIds.contains(message.id))
        .length;
  }

  /// Marks a specific message as viewed
  Future<void> markMessageAsViewed(String messageId) async {
    if (!_viewedMessageIds.contains(messageId)) {
      _viewedMessageIds.add(messageId);
      await _saveViewedMessageIds();
      _calculateUnreadCount();
      notifyListeners();
    }
  }

  /// Marks all current messages as viewed
  Future<void> markAllMessagesAsViewed() async {
    _viewedMessageIds.addAll(_activeMessages.map((msg) => msg.id));
    await _saveViewedMessageIds();
    _unreadCount = 0;
    notifyListeners();
  }

  /// Checks for new messages by comparing with current state
  Future<void> checkForNewMessages() async {
    try {
      final currentMessages = await _messagingService.getActiveMessages();

      // Check if we have new messages
      final currentMessageIds = _activeMessages.map((msg) => msg.id).toSet();
      final newMessageIds = currentMessages.map((msg) => msg.id).toSet();

      // Find new messages (messages in current but not in previous)
      final trulyNewMessageIds = newMessageIds.difference(currentMessageIds);

      if (trulyNewMessageIds.isNotEmpty) {
        // We have new messages, update the list
        _activeMessages = currentMessages;
        _calculateUnreadCount();
        notifyListeners();
      }
    } catch (e) {
      // Log error but don't update UI state for background checks
      debugPrint('Error checking for new messages: $e');
    }
  }

  /// Refreshes messages (equivalent to loadActiveMessages but with different intent)
  Future<void> refreshMessages() async {
    await loadActiveMessages();
  }

  /// Resets the provider state (useful for testing or logout)
  Future<void> reset() async {
    _activeMessages.clear();
    _viewedMessageIds.clear();
    _isLoading = false;
    _errorMessage = null;
    _unreadCount = 0;

    // Clear persisted data
    if (_prefs != null) {
      await _prefs!.remove(_viewedMessagesKey);
    }

    notifyListeners();
  }
}
