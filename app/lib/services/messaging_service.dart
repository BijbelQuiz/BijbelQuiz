import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../config/supabase_config.dart';
import '../utils/automatic_error_reporter.dart';
import '../services/analytics_service.dart';

/// Represents a message in the system with expiration capability
class Message {
  final String id;
  final String title;
  final String content;
  final DateTime? expirationDate;
  final DateTime createdAt;
  final String? createdBy;

  Message({
    required this.id,
    required this.title,
    required this.content,
    this.expirationDate,
    required this.createdAt,
    this.createdBy,
  });

  /// Creates a Message instance from a Map (typically from Supabase response)
  factory Message.fromMap(Map<String, dynamic> map) {
    DateTime? expirationDate;
    if (map['expiration_date'] != null) {
      expirationDate = DateTime.parse(map['expiration_date'] as String);
    }
    
    return Message(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      expirationDate: expirationDate,
      createdAt: DateTime.parse(map['created_at'] as String),
      createdBy: map['created_by'] as String?,
    );
  }

  /// Converts a Message instance to a Map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'expiration_date': expirationDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }
}

/// Service class for handling messaging functionality
class MessagingService {
  /// Gets the Supabase client for database operations
  SupabaseClient get _client => SupabaseConfig.client;

  /// Gets all active messages (not expired) from the database
  Future<List<Message>> getActiveMessages() async {
    try {
      final now = DateTime.now().toIso8601String();
      
      final response = await _client
          .from('messages')
          .select('*')
          .or('expiration_date.is.null,expiration_date.gte.$now')
          .order('created_at', ascending: false);

      return response.map((map) => Message.fromMap(map)).toList();
    } catch (e) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Error fetching active messages',
        additionalInfo: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Gets a specific message by ID
  Future<Message?> getMessageById(String id) async {
    try {
      final response = await _client
          .from('messages')
          .select('*')
          .eq('id', id)
          .single();

      return Message.fromMap(response);
    } catch (e) {
      // If no message is found (single() throws error), return null
      if (e is PostgrestException && e.code == 'PGRST116') {
        return null;
      }
      
      AutomaticErrorReporter.reportStorageError(
        message: 'Error fetching message by ID',
        additionalInfo: {'message_id': id, 'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Checks if a message is still active (not expired)
  bool isMessageActive(Message message) {
    // If no expiration date is set, the message is always active
    if (message.expirationDate == null) {
      return true;
    }
    // Otherwise, check if the current time is before the expiration date
    return DateTime.now().isBefore(message.expirationDate!);
  }

  /// Creates a new message in the database
  /// This function would typically only be called by admin users
  Future<Message> createMessage({
    required String title,
    required String content,
    DateTime? expirationDate,
    String? createdBy,
  }) async {
    try {
      final newMessage = {
        'title': title,
        'content': content,
        'expiration_date': expirationDate?.toIso8601String(), // Optional expiration date
        'created_at': DateTime.now().toIso8601String(),
        'created_by': createdBy,
      };

      final response = await _client
          .from('messages')
          .insert(newMessage)
          .select()
          .single();

      return Message.fromMap(response);
    } catch (e) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Error creating message',
        additionalInfo: {
          'title': title, 
          'expiration_date': expirationDate?.toIso8601String(), 
          'error': e.toString()
        },
      );
      rethrow;
    }
  }

  /// Updates an existing message
  /// This function would typically only be called by admin users
  Future<Message> updateMessage({
    required String id,
    String? title,
    String? content,
    DateTime? expirationDate,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (content != null) updateData['content'] = content;
      if (expirationDate != null) updateData['expiration_date'] = expirationDate.toIso8601String();

      final response = await _client
          .from('messages')
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      return Message.fromMap(response);
    } catch (e) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Error updating message',
        additionalInfo: {'message_id': id, 'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Deletes a message from the database
  /// This function would typically only be called by admin users
  Future<void> deleteMessage(String id) async {
    try {
      await _client
          .from('messages')
          .delete()
          .eq('id', id);
    } catch (e) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Error deleting message',
        additionalInfo: {'message_id': id, 'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Validates message data before creation/update
  bool validateMessage({
    required String title,
    required String content,
    required DateTime expirationDate,
  }) {
    // Title and content should not be empty
    if (title.trim().isEmpty || content.trim().isEmpty) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Message validation failed: title or content is empty',
        additionalInfo: {'title_length': title.length, 'content_length': content.length},
      );
      return false;
    }

    // Expiration date should be in the future
    if (!expirationDate.isAfter(DateTime.now())) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Message validation failed: expiration date is not in the future',
        additionalInfo: {'expiration_date': expirationDate.toIso8601String(), 'current_time': DateTime.now().toIso8601String()},
      );
      return false;
    }

    // Title should not exceed 200 characters
    if (title.length > 200) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Message validation failed: title exceeds 200 characters',
        additionalInfo: {'title_length': title.length},
      );
      return false;
    }

    // Content should not exceed 10000 characters
    if (content.length > 10000) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Message validation failed: content exceeds 10000 characters',
        additionalInfo: {'content_length': content.length},
      );
      return false;
    }

    return true;
  }

  /// Tracks when a user views messages
  void trackMessagesViewed(AnalyticsService analyticsService, BuildContext? context) {
    if (context != null) {
      analyticsService.trackFeatureUsage(context, 'messaging', 'messages_viewed');
    }
  }

  /// Tracks when a user refreshes messages
  void trackMessagesRefreshed(AnalyticsService analyticsService, BuildContext? context) {
    if (context != null) {
      analyticsService.trackFeatureUsage(context, 'messaging', 'refresh_triggered');
    }
  }

  /// Tracks when a message is viewed in detail
  void trackMessageDetailView(AnalyticsService analyticsService, BuildContext? context, String messageId) {
    if (context != null) {
      analyticsService.trackFeatureUsage(
        context, 
        'messaging', 
        'message_detail_viewed',
        additionalProperties: {'message_id': messageId}
      );
    }
  }
}