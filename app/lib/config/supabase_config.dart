import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import '../services/logger.dart';
import '../services/app_config.dart';

class SupabaseConfig {
  static SupabaseClient? _client;
  static String? _supabaseUrl;

  static bool get isInitialized => _client != null;
  static SupabaseClient? get maybeClient => _client;

  static Future<void> initialize() async {
    AppLogger.info('Starting Supabase initialization...');
    final supabaseInitStart = DateTime.now();

    Logger.root.level = Level.WARNING;
    AppLogger.info('Setting Supabase logging level...');
    
    AppLogger.info('Loading configuration from backend...');
    final appConfig = AppConfig();
    await appConfig.loadFromBackend();

    if (appConfig.supabaseUrl.isEmpty) {
      AppLogger.error('SUPABASE_URL environment variable is not set');
      throw Exception('SUPABASE_URL environment variable is not set');
    }

    _supabaseUrl = appConfig.supabaseUrl;

    if (appConfig.supabasePublishableKey.isEmpty) {
      AppLogger.error('SUPABASE_PUBLISHABLE_KEY environment variable is not set');
      throw Exception('SUPABASE_PUBLISHABLE_KEY environment variable is not set');
    }

    AppLogger.info('Supabase configuration validated successfully');

    AppLogger.info('Initializing Supabase client...');
    final supabaseClientInitStart = DateTime.now();
    await Supabase.initialize(
      url: appConfig.supabaseUrl,
      anonKey: appConfig.supabasePublishableKey,
    );
    final supabaseClientInitDuration =
        DateTime.now().difference(supabaseClientInitStart);
    AppLogger.info(
        'Supabase client initialized in ${supabaseClientInitDuration.inMilliseconds}ms');

    _client = Supabase.instance.client;
    AppLogger.info('Supabase client instance obtained');

    final totalDuration = DateTime.now().difference(supabaseInitStart);
    AppLogger.info(
        'Supabase initialization completed in ${totalDuration.inMilliseconds}ms');
  }

  static SupabaseClient getClient() {
    final client = _client;
    if (client == null) {
      throw StateError('Supabase client is not initialized');
    }
    return client;
  }

  static String getUrl() {
    final url = _supabaseUrl;
    if (url == null) {
      throw StateError('Supabase URL is not initialized');
    }
    return url;
  }
}
