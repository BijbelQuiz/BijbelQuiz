import 'package:flutter/material.dart';

class EmergencyMessageDialog extends StatelessWidget {
  final String message;
  final bool isBlocking;
  final VoidCallback? onDismiss;

  const EmergencyMessageDialog({
    super.key,
    required this.message,
    required this.isBlocking,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isBlocking,
      child: AlertDialog(
        title: const Text('Belangrijke mededeling', 
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: <Widget>[
          if (!isBlocking)
            TextButton(
              child: const Text('Sluiten'),
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
            ),
          if (isBlocking)
            Text(
              'Deze melding kan niet worden gesloten',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
