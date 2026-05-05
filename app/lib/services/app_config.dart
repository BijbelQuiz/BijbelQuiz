import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/urls.dart';

class AppConfig {
  String? _supabaseUrl;
  String? _supabasePublishableKey;
  String? _posthogHost;

  bool get isLoaded => _supabaseUrl != null && _supabasePublishableKey != null;

  String get supabaseUrl => _supabaseUrl!;
  String get supabasePublishableKey => _supabasePublishableKey!;
  String get posthogHost => _posthogHost ?? 'https://us.i.posthog.com';

  Future<void> loadFromBackend() async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrls.backendDomain}/api/config'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _supabaseUrl = data['supabaseUrl'] as String?;
        _supabasePublishableKey = data['supabasePublishableKey'] as String?;
        _posthogHost = data['posthogHost'] as String? ?? 'https://us.i.posthog.com';
      } else {
        throw Exception('Failed to load config: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load config from backend: $e');
    }
  }
}