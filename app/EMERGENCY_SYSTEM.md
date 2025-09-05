# Emergency Message System

The BijbelQuiz app includes an emergency message system that allows administrators to display important messages to all app users. This system consists of:

1. A REST API hosted on Vercel
2. A Flutter service that polls the API for messages
3. A dialog that displays emergency messages to users

## How It Works

The `EmergencyService` in the Flutter app polls the API endpoint `https://bijbelquiz.app/api/emergency` every 5 minutes. When an emergency message is detected, it displays a dialog to the user using the `EmergencyMessageDialog` widget.

## Message Types

Emergency messages can be either:
- **Dismissible**: Users can close the dialog and continue using the app
- **Blocking**: Users cannot close the dialog (used for critical messages)

## Admin Tool

Administrators can use the `emergency_message_tool.py` script to:
- Send emergency messages
- Clear existing messages
- Check the current message status

## API Endpoints

- `GET /api/emergency` - Check for current emergency message
- `POST /api/emergency` - Set an emergency message (requires authentication)
- `DELETE /api/emergency` - Clear the emergency message (requires authentication)

## Authentication

The API requires a Bearer token for administrative operations. This token should be set in the `ADMIN_TOKEN` environment variable on the server.

## Testing

To test the emergency message system:
1. Run the `emergency_message_tool.py` script
2. Enter a valid admin token
3. Type a test message
4. Click "Send Message"
5. The message should appear in the app within 5 minutes (or restart the app to see it immediately)