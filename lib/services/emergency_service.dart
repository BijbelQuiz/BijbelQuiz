import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bijbelquiz/widgets/emergency_message_dialog.dart';

class EmergencyMessage {
  final String message;
  final bool isBlocking;
  final DateTime expiresAt;

  EmergencyMessage({
    required this.message,
    required this.isBlocking,
    required this.expiresAt,
  });

  factory EmergencyMessage.fromJson(Map<String, dynamic> json) {
    return EmergencyMessage(
      message: json['message'],
      isBlocking: json['isBlocking'] ?? false,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(json['expiresAt'] * 1000),
    );
  }
}

class EmergencyService {
  static const String _baseUrl = 'https://backendbijbelquiz.vercel.app/api';
  static const String _endpoint = '/emergency';
  static const Duration _pollingInterval = Duration(minutes: 5);
  
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Timer? _pollingTimer;
  EmergencyMessage? _currentMessage;
  bool _isShowingDialog = false;

  EmergencyService();

  // Start polling for emergency messages
  void startPolling() {
    // Initial check
    _checkForEmergency();
    
    // Set up periodic polling
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      _checkForEmergency();
    });
  }

  // Stop polling
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  // Check for emergency messages from the server
  Future<void> _checkForEmergency() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // We have an emergency message
        final data = jsonDecode(response.body);
        final message = EmergencyMessage.fromJson(data);
        
        // Only show if it's a new message or different from current one
        if (_currentMessage?.message != message.message) {
          _currentMessage = message;
          _showEmergencyDialog(message);
        }
      } else if (response.statusCode == 204) {
        // No emergency message
        _currentMessage = null;
      }
    } catch (e) {
      // Log error but don't show to user
      debugPrint('Error checking for emergency message: $e');
    }
  }

  // Show the emergency dialog
  void _showEmergencyDialog(EmergencyMessage message) async {
    // Prevent multiple dialogs
    if (_isShowingDialog) return;
    _isShowingDialog = true;
    
    // Use the navigator key to show the dialog
    if (navigatorKey.currentContext != null) {
      await showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: !message.isBlocking,
        builder: (BuildContext context) {
          return EmergencyMessageDialog(
            message: message.message,
            isBlocking: message.isBlocking,
            onDismiss: () => _isShowingDialog = false,
          );
        },
      );
    }
    
    _isShowingDialog = false;
  }

  // Clean up resources
  void dispose() {
    stopPolling();
  }
}
