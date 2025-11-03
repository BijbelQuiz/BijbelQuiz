import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

class SupabaseConfig {
  static late SupabaseClient client;

  static Future<void> initialize() async {
    // Set Supabase logging level to reduce verbosity
    Logger.root.level = Level.WARNING;
    
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
    client = Supabase.instance.client;
  }

  /// Gets the Supabase client for database operations
  static SupabaseClient getClient() {
    return client;
  }
}