import 'package:flutter_test/flutter_test.dart';
import 'package:bijbelquiz/services/emergency_service.dart';

void main() {
  group('EmergencyService', () {
    test('Can be instantiated', () {
      final service = EmergencyService();
      expect(service, isNotNull);
    });

    test('EmergencyMessage can parse JSON', () {
      final json = {
        'message': 'Test emergency message',
        'isBlocking': true,
        'expiresAt': 1755784863208, // Example timestamp in milliseconds
      };

      final message = EmergencyMessage.fromJson(json);
      expect(message.message, 'Test emergency message');
      expect(message.isBlocking, true);
      expect(message.expiresAt, isA<DateTime>());
    });
  });
}