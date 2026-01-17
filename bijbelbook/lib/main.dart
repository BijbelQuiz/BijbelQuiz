import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart' show Level, Logger;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/supabase_config.dart';
import 'services/logger.dart';
import 'screens/home_screen.dart';
import 'l10n/strings_nl.dart' as strings;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.setSecureLevel(
    isProduction: const bool.fromEnvironment('dart.vm.product'),
    productionLevel: Level.WARNING,
    developmentLevel: Level.ALL,
  );
  AppLogger.init();
  AppLogger.info('BijbelBook app starting up...');

  try {
    await dotenv.load(fileName: "assets/.env");
    await SupabaseConfig.initialize();
  } catch (e) {
    AppLogger.error('Error during initialization', e);
  }

  runApp(const BijbelBookApp());
}

class BijbelBookApp extends StatelessWidget {
  const BijbelBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: strings.AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Quicksand',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Quicksand',
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('nl', ''), Locale('en', '')],
      locale: const Locale('nl', ''),
      home: const HomeScreen(),
    );
  }
}
