# Emergency Popup System

This document explains how to use the emergency popup system in the BijbelQuiz application, including both the API and the admin tool.

## Overview

The emergency popup system allows administrators to display important messages to all app users. Messages can be configured as either dismissible or blocking (app-blocking). The system includes both a REST API and a Python-based GUI tool for managing emergency messages.

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

## Client-Side Implementation

The Flutter app automatically polls the emergency endpoint every 5 minutes. When an emergency message is received, it's displayed immediately to the user.

### Message Types
1. **Dismissible Message**:
   - User can close the message
   - Message will reappear if still active on next poll

2. **Blocking Message**:
   - User cannot dismiss the message
   - App functionality is blocked until the message is cleared server-side

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

## Best Practices

1. Use blocking messages only for critical issues
2. Keep messages clear and concise
3. Always include an expiration time for blocking messages
4. Test messages in a staging environment first
5. Monitor the system after sending a message to ensure it's working as expected
