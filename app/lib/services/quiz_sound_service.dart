import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'sound_service.dart';

/// Shared service for handling quiz-related sounds with mute support
class QuizSoundService {
  final SoundService _soundService;

  QuizSoundService(this._soundService);

  /// Play correct answer sound with mute check
  Future<void> playCorrectAnswerSound(BuildContext context) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.mute) return;

    try {
      await _soundService.playCorrect();
    } catch (e) {
      debugPrint('Error playing correct sound: $e');
    }
  }

  /// Play incorrect answer sound with mute check
  Future<void> playIncorrectAnswerSound(BuildContext context) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.mute) return;

    try {
      await _soundService.playIncorrect();
    } catch (e) {
      debugPrint('Error playing incorrect sound: $e');
    }
  }
}
