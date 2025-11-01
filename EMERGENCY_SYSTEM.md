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

### Client-Side Implementation

The Flutter app automatically polls the emergency endpoint every 5 minutes. When an emergency message is received, it's displayed immediately to the user.

1. **Dismissible Message**:
   - User can close the message
   - Message will reappear if still active on next poll

2. **Blocking Message**:
   - User cannot dismiss the message
   - App functionality is blocked until the message is cleared server-side

## API Endpoints

### Get Emergency Message

- **URL**: `GET /api/emergency`
- **Response**:
  - `204 No Content`: No active emergency message
  - `200 OK`: Returns the active emergency message

```json
{
  "message": "Emergency message text",
  "isBlocking": true,
  "expiresAt": 1234567890
}
```

### Set Emergency Message

- **URL**: `POST /api/emergency`
- **Headers**:
  - `Authorization: Bearer <ADMIN_TOKEN>`
  - `Content-Type: application/json`
- **Body**:

```json
{
  "message": "Your emergency message here",
  "isBlocking": false
}
```

- **Response**:
  - `200 OK`: Message set successfully
  - `401 Unauthorized`: Invalid or missing admin token
  - `400 Bad Request`: Invalid request body

### Clear Emergency Message

- **URL**: `DELETE /api/emergency`
- **Headers**:
  - `Authorization: Bearer <ADMIN_TOKEN>`
- **Response**:
  - `200 OK`: Message cleared successfully
  - `401 Unauthorized`: Invalid or missing admin token

## Authentication

The API requires a Bearer token for administrative operations. This token should be set in the `ADMIN_TOKEN` environment variable on the server.

## Admin Tool

The `emergency_message_tool.py` provides a graphical interface for managing emergency messages without writing code.

### Features

- Send emergency messages (both dismissible and blocking)
- Clear existing emergency messages
- Check current message status
- Simple GUI interface

### Requirements

- Python 3.6+
- Required packages: `requests`, `tkinter`

### Installation

1. Ensure Python 3.6+ is installed
2. Install required packages:

   ```bash
   pip install requests
   ```

### Usage

1. Run the tool:

   ```bash
   python3 emergency_message_tool.py
   ```

2. Enter your admin token in the "Admin Token" field
3. Type your message in the text area
4. Check "Blocking" if the message should prevent app usage
5. Click "Send Message" to broadcast the message
6. Use "Clear Message" to remove the current emergency message
7. Use "Check Status" to view the current active message

## Setup Instructions

1. **Environment Variables**:
   - Set the `ADMIN_TOKEN` environment variable on your Vercel deployment
   - This token is required to set or clear emergency messages

2. **Testing**:
   - Use the `test_emergency_api.js` script to test the API
   - Or use the provided Python tool: `python3 emergency_message_tool.py`
   - Set your admin token in the tool's interface

## Testing

To test the emergency message system:

1. Run the `emergency_message_tool.py` script
2. Enter a valid admin token
3. Type a test message
4. Click "Send Message"
5. The message should appear in the app within 5 minutes (or restart the app to see it immediately)

## Best Practices

1. Use blocking messages only for critical issues
2. Keep messages clear and concise
3. Always include an expiration time for blocking messages
4. Test messages in a staging environment first
5. Monitor the system after sending a message to ensure it's working as expected
