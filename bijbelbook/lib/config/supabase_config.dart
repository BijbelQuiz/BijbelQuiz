import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import '../services/logger.dart';

class SupabaseConfig {
  static late SupabaseClient client;
  static late String supabaseUrl;

  static Future<void> initialize() async {
    AppLogger.info('Starting Supabase initialization...');
    final supabaseInitStart = DateTime.now();

    AppLogger.info('Setting Supabase logging level...');
    Logger.root.level = Level.WARNING;

    AppLogger.info('Loading Supabase environment variables...');
    final envLoadStart = DateTime.now();
    final url = dotenv.env['SUPABASE_URL'];
    final supabasePublishableKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];
    final envLoadDuration = DateTime.now().difference(envLoadStart);
    AppLogger.info(
      'Supabase environment variables loaded in ${envLoadDuration.inMilliseconds}ms',
    );

    AppLogger.info('Validating Supabase configuration...');
    if (url == null || url.isEmpty) {
      AppLogger.error('SUPABASE_URL environment variable is not set');
      throw Exception('SUPABASE_URL environment variable is not set');
    }

    SupabaseConfig.supabaseUrl = url;

    if (supabasePublishableKey == null || supabasePublishableKey.isEmpty) {
      AppLogger.error(
        'SUPABASE_PUBLISHABLE_KEY environment variable is not set',
      );
      throw Exception(
        'SUPABASE_PUBLISHABLE_KEY environment variable is not set',
      );
    }

    AppLogger.info('Supabase configuration validated successfully');

    AppLogger.info('Initializing Supabase client...');
    final supabaseClientInitStart = DateTime.now();
    await Supabase.initialize(url: url, anonKey: supabasePublishableKey);
    final supabaseClientInitDuration = DateTime.now().difference(
      supabaseClientInitStart,
    );
    AppLogger.info(
      'Supabase client initialized in ${supabaseClientInitDuration.inMilliseconds}ms',
    );

    client = Supabase.instance.client;
    AppLogger.info('Supabase client instance obtained');

    final totalDuration = DateTime.now().difference(supabaseInitStart);
    AppLogger.info(
      'Supabase initialization completed in ${totalDuration.inMilliseconds}ms',
    );
  }

  static SupabaseClient getClient() {
    return client;
  }

  static String getUrl() {
    return supabaseUrl;
  }
}
