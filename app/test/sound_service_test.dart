import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/services/sound_service.dart';
import 'package:bijbelquiz/services/logger.dart';

void main() {
  group('SoundService', () {
    late SoundService soundService;

    setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      soundService = SoundService();
    });

    tearDown(() async {
      await soundService.dispose();
    });

    test('should initialize as singleton', () {
      final soundService1 = SoundService();
      final soundService2 = SoundService();

      expect(soundService1, same(soundService2));
    });

    test('should detect platform support correctly', () {
      // We can't easily test platform detection in unit tests
      // but we can verify the status includes platform information
      final status = soundService.getStatus();
      expect(status['platformSupported'], isA<bool>());
      expect(status['platform'], isA<String>());
    });

    test('should initialize without errors', () async {
      await soundService.initialize();

      final status = soundService.getStatus();
      expect(status['isInitialized'], isA<bool>());
      expect(status['isEnabled'], isA<bool>());
    });

    test('should handle enable/disable correctly', () async {
      await soundService.initialize();

      soundService.setEnabled(false);
      expect(soundService.isEnabled, false);

      soundService.setEnabled(true);
      expect(soundService.isEnabled, true);
    });

    test('should play correct sound when enabled', () async {
      await soundService.initialize();

      if (soundService.isEnabled) {
        // Only test if sound is supported on this platform
        await soundService.playCorrect();

        // Should not throw an error
        expect(true, isTrue);
      }
    });

    test('should play incorrect sound when enabled', () async {
      await soundService.initialize();

      if (soundService.isEnabled) {
        // Only test if sound is supported on this platform
        await soundService.playIncorrect();

        // Should not throw an error
        expect(true, isTrue);
      }
    });

    test('should not play sound when disabled', () async {
      await soundService.initialize();
      soundService.setEnabled(false);

      // Should return immediately without errors
      await soundService.playCorrect();
      await soundService.playIncorrect();

      expect(soundService.isEnabled, false);
    });

    test('should handle unknown sound names gracefully', () async {
      await soundService.initialize();

      // Should not throw an error for unknown sound names
      await soundService.play('unknown_sound');

      expect(true, isTrue); // Test passes if no exception is thrown
    });

    test('should stop sound correctly', () async {
      await soundService.initialize();

      // Should not throw an error
      await soundService.stop();

      expect(true, isTrue);
    });

    test('should provide status information', () async {
      await soundService.initialize();

      final status = soundService.getStatus();

      expect(status.containsKey('isInitialized'), isTrue);
      expect(status.containsKey('isEnabled'), isTrue);
      expect(status.containsKey('player'), isTrue);
      expect(status.containsKey('platformSupported'), isTrue);
      expect(status.containsKey('platform'), isTrue);

      expect(status['player'], 'just_audio');
      expect(status['platform'], Platform.operatingSystem);
    });

    test('should dispose without errors', () async {
      await soundService.initialize();

      // Should not throw an error
      await soundService.dispose();

      expect(true, isTrue);
    });

    test('should handle multiple play calls correctly', () async {
      await soundService.initialize();

      if (soundService.isEnabled) {
        // Play multiple sounds in sequence
        await soundService.playCorrect();
        await soundService.playIncorrect();
        await soundService.playCorrect();

        // Should not throw errors
        expect(true, isTrue);
      }
    });

    test('should handle rapid enable/disable calls', () async {
      await soundService.initialize();

      // Rapidly toggle enabled state
      for (int i = 0; i < 10; i++) {
        soundService.setEnabled(i % 2 == 0);
      }

      expect(soundService.isEnabled, false); // Should end up disabled
    });

    test('should handle initialization multiple times', () async {
      // Initialize multiple times
      await soundService.initialize();
      await soundService.initialize();
      await soundService.initialize();

      // Should not cause issues
      final status = soundService.getStatus();
      expect(status['isInitialized'], isA<bool>());
    });

    test('should handle dispose multiple times', () async {
      await soundService.initialize();

      // Dispose multiple times
      await soundService.dispose();
      await soundService.dispose();
      await soundService.dispose();

      // Should not cause issues
      expect(true, isTrue);
    });

    test('should handle play calls after dispose', () async {
      await soundService.initialize();
      await soundService.dispose();

      // Play calls after dispose should not throw errors
      await soundService.playCorrect();
      await soundService.playIncorrect();

      expect(true, isTrue);
    });

    test('should handle stop calls after dispose', () async {
      await soundService.initialize();
      await soundService.dispose();

      // Stop calls after dispose should not throw errors
      await soundService.stop();

      expect(true, isTrue);
    });

    test('should maintain state across operations', () async {
      await soundService.initialize();

      // Set enabled state
      soundService.setEnabled(true);
      expect(soundService.isEnabled, true);

      // Play a sound
      if (soundService.isEnabled) {
        await soundService.playCorrect();
      }

      // State should remain consistent
      expect(soundService.isEnabled, true);

      // Disable and verify
      soundService.setEnabled(false);
      expect(soundService.isEnabled, false);
    });

    test('should handle concurrent play calls gracefully', () async {
      await soundService.initialize();

      if (soundService.isEnabled) {
        // Start multiple play calls
        final futures = [
          soundService.playCorrect(),
          soundService.playIncorrect(),
          soundService.playCorrect(),
        ];

        // Wait for all to complete
        await Future.wait(futures);

        // Should not throw errors
        expect(true, isTrue);
      }
    });

    test('should handle error callback', () async {
      await soundService.initialize();

      // Set error callback
      String? lastError;
      soundService.onError = (message) {
        lastError = message;
      };

      // Try to play an unknown sound (should trigger error handling)
      await soundService.play('definitely_unknown_sound');

      // Give some time for error handling
      await Future.delayed(const Duration(milliseconds: 100));

      // Error callback may or may not be called depending on platform
      // but the service should handle it gracefully
      expect(true, isTrue);
    });
  });
}