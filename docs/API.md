# BijbelQuiz Local API Documentation

## Overview

The BijbelQuiz app includes a local HTTP API server that allows external applications to access quiz questions, user progress, and game statistics. This API is designed for integration with other apps, tools, or services that need access to BijbelQuiz data.

## Features

- **Local Network Access**: Runs on a configurable local port (default: 8080)
- **Secure Authentication**: API key-based authentication via Bearer token or X-API-Key header
- **RESTful Endpoints**: Standard HTTP methods for data access
- **JSON Responses**: Structured data format for easy integration
- **CORS Support**: Cross-origin requests supported for web integration
- **Real-time Status**: Live API server status monitoring

## Setup

### 1. Enable the API

1. Open BijbelQuiz app
2. Go to **Settings** → **Local API**
3. Toggle **"Enable Local API"** to ON
4. Click **"Generate Key"** to create an API key
5. Optionally change the **API Port** (default: 8080)

### 2. API Key Management

- **Generate New Key**: Creates a new API key and invalidates the previous one
- **Key Format**: `bq_` followed by a 16-character alphanumeric string
- **Security**: Keep your API key secure and don't share it publicly

### 3. Network Access

The API server binds to `0.0.0.0` (all network interfaces), making it accessible from:
- Local machine: `http://localhost:8080`
- Local network: `http://[device-ip]:8080`
- External tools: Use your device's IP address

## Authentication

All API endpoints (except `/health`) require authentication using your API key.

### Authentication Methods

#### 1. Bearer Token (Recommended)
```bash
curl -H "Authorization: Bearer your-api-key" \
     http://localhost:8080/questions
```

#### 2. API Key Header
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/questions
```

### Error Response (Invalid/Missing Key)
```json
{
  "error": "Invalid or missing API key",
  "message": "Please provide a valid API key via Authorization header (Bearer token) or X-API-Key header"
}
```

## Endpoints

### Base URL
```
http://localhost:8080
```

### 1. Health Check
**GET** `/health`

Check if the API server is running and healthy.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-20T16:45:49.539Z",
  "service": "BijbelQuiz API"
}
```

**Usage:**
```bash
curl http://localhost:8080/health
```

### 2. Get Questions
**GET** `/questions`

Retrieve quiz questions with optional filtering.

**Query Parameters:**
- `category` (optional): Filter by category (e.g., "Genesis", "Matteüs")
- `limit` (optional): Number of questions to return (default: 10, max: 50)
- `difficulty` (optional): Filter by difficulty level (1-5)

**Response:**
```json
{
  "questions": [
    {
      "question": "Hoeveel Bijbelboeken heeft het Nieuwe Testament?",
      "correctAnswer": "27",
      "incorrectAnswers": ["26", "66", "39"],
      "difficulty": 3,
      "type": "mc",
      "categories": ["Nieuwe Testament"],
      "biblicalReference": null,
      "allOptions": ["27", "26", "66", "39"],
      "correctAnswerIndex": 0
    }
  ],
  "count": 1,
  "category": "Nieuwe Testament",
  "difficulty": null
}
```

**Examples:**
```bash
# Get 10 random questions
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/questions?limit=10

# Get questions from Genesis category
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/questions?category=Genesis&limit=5

# Get hard difficulty questions
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/questions?difficulty=4&limit=20
```

### 3. Get Questions by Category
**GET** `/questions/{category}`

Get questions from a specific category.

**Path Parameters:**
- `category`: The category name (e.g., "Genesis", "Psalmen")

**Query Parameters:**
- `limit` (optional): Number of questions to return (default: 10, max: 50)
- `difficulty` (optional): Filter by difficulty level (1-5)

**Response:** Same format as `/questions` endpoint

**Examples:**
```bash
# Get questions from Psalms
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/questions/Psalmen?limit=15

# Get easy questions from Proverbs
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/questions/Spreuken?difficulty=2
```

### 4. Get User Progress
**GET** `/progress`

Retrieve user's lesson progress and unlock status.

**Response:**
```json
{
  "unlockedCount": 5,
  "bestStarsByLesson": {
    "lesson_1": 3,
    "lesson_2": 2,
    "lesson_3": 3,
    "lesson_4": 1,
    "lesson_5": 2
  }
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/progress
```

### 5. Get Game Statistics
**GET** `/stats`

Retrieve current game statistics and performance metrics.

**Response:**
```json
{
  "score": 1250,
  "currentStreak": 7,
  "longestStreak": 15,
  "incorrectAnswers": 23
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/stats
```

### 6. Get App Settings
**GET** `/settings`

Retrieve current app settings and preferences.

**Response:**
```json
{
  "themeMode": "dark",
  "gameSpeed": "medium",
  "mute": false,
  "analyticsEnabled": true,
  "notificationEnabled": true
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/settings
```

## Response Formats

### Success Responses

All successful responses return JSON with appropriate HTTP status codes:
- `200 OK`: Successful request
- `204 No Content`: No data available (for empty results)

### Error Responses

Error responses include HTTP error status codes and JSON error details:

```json
{
  "error": "Error type description",
  "message": "Detailed error message"
}
```

**Common HTTP Status Codes:**
- `400 Bad Request`: Invalid request parameters
- `401 Unauthorized`: Missing or invalid API key
- `403 Forbidden`: Valid API key but insufficient permissions
- `404 Not Found`: Endpoint or resource not found
- `500 Internal Server Error`: Server-side error

## Data Types

### Question Types
- `mc`: Multiple Choice
- `fitb`: Fill in the Blank
- `tf`: True/False

### Difficulty Levels
- `1`: Very Easy
- `2`: Easy
- `3`: Medium
- `4`: Hard
- `5`: Very Hard

## Rate Limiting

The API implements basic rate limiting to prevent abuse:
- Maximum 100 requests per minute per IP address
- Requests exceeding the limit return `429 Too Many Requests`

## Integration Examples

### Python Example
```python
import requests

API_KEY = "your-api-key-here"
BASE_URL = "http://localhost:8080"

def get_questions(category=None, limit=10):
    headers = {"X-API-Key": API_KEY}
    params = {"limit": limit}
    if category:
        params["category"] = category

    response = requests.get(f"{BASE_URL}/questions", headers=headers, params=params)
    response.raise_for_status()
    return response.json()

# Usage
questions = get_questions(category="Genesis", limit=5)
print(f"Retrieved {questions['count']} questions")
for q in questions['questions']:
    print(f"Q: {q['question']}")
    print(f"A: {q['correctAnswer']}")
```

### JavaScript/Node.js Example
```javascript
const API_KEY = "your-api-key-here";
const BASE_URL = "http://localhost:8080";

async function getQuestions(category = null, limit = 10) {
    const headers = {
        "X-API-Key": API_KEY
    };

    const params = new URLSearchParams({ limit: limit.toString() });
    if (category) {
        params.append("category", category);
    }

    const response = await fetch(`${BASE_URL}/questions?${params}`, { headers });
    if (!response.ok) {
        throw new Error(`API error: ${response.status}`);
    }
    return await response.json();
}

// Usage
getQuestions("Psalmen", 10)
    .then(data => {
        console.log(`Retrieved ${data.count} questions`);
        data.questions.forEach(q => {
            console.log(`Q: ${q.question}`);
            console.log(`A: ${q.correctAnswer}`);
        });
    })
    .catch(error => console.error("Error:", error));
```

### Command Line Examples
```bash
# Health check
curl http://localhost:8080/health

# Get 5 random questions
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/questions?limit=5

# Get questions from Matthew with Bearer token
curl -H "Authorization: Bearer your-api-key" \
     http://localhost:8080/questions?category=Matteüs&limit=10

# Get user progress
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/progress

# Get game statistics
curl -H "X-API-Key: your-api-key" \
     http://localhost:8080/stats
```

## Troubleshooting

### Common Issues

1. **Connection Refused**
   - Ensure the API is enabled in BijbelQuiz settings
   - Check that the port (default: 8080) is not blocked by firewall
   - Verify the app is running and not in background

2. **Authentication Failed**
   - Ensure you're using the correct API key
   - Check that the API key hasn't been regenerated
   - Try both Bearer token and X-API-Key header methods

3. **No Questions Returned**
   - Check if questions are loaded in the BijbelQuiz app
   - Verify category names are spelled correctly
   - Try without category filter to see if questions are available

4. **Port Already in Use**
   - Change the API port in BijbelQuiz settings
   - Check what process is using the port: `netstat -tulpn | grep :8080`

### Debug Mode

Enable debug logging in BijbelQuiz settings to see detailed API server logs:
- Go to Settings → Privacy & Analytics → Enable Analytics (for logging)

### Network Discovery

To find your device's IP address:
```bash
# Linux/macOS
ip addr show | grep "inet " | grep -v 127.0.0.1

# Windows
ipconfig

# Android (termux)
ip addr show wlan0
```

## Security Considerations

1. **API Key Protection**: Keep your API key secure and don't commit it to version control
2. **Network Exposure**: The API is accessible from your local network - be aware of this when using on public WiFi
3. **Firewall Configuration**: Consider firewall rules if you need to restrict access to specific IP ranges
4. **Key Rotation**: Regularly regenerate your API key for enhanced security

## Performance

- **Response Time**: Typically <100ms for local requests
- **Memory Usage**: Minimal additional memory usage when API is enabled
- **Concurrent Requests**: Supports multiple simultaneous requests
- **Caching**: Questions are cached in the BijbelQuiz app for fast retrieval

## Support

For API-related issues:
1. Check the troubleshooting section above
2. Verify your setup matches the documentation
3. Test with simple `curl` commands first
4. Check BijbelQuiz app logs for error details

## Changelog

### Version 1.0.0
- Initial API implementation
- Basic authentication and question endpoints
- Progress and statistics endpoints
- Settings endpoint for app configuration