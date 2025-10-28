# BijbelQuiz Local API Documentation

## Overview

The BijbelQuiz app includes a local HTTP API server that allows external applications to access quiz questions, user progress, and game statistics. This API is designed for integration with other apps, tools, or services that need access to BijbelQuiz data.

## Features

- **Local Network Access**: Runs on a configurable local port (default: 7777)
- **Secure Authentication**: API key-based authentication via Bearer token or X-API-Key header
- **RESTful Endpoints**: Standard HTTP methods for data access with versioning support
- **JSON Responses**: Structured data format for easy integration
- **CORS Support**: Cross-origin requests supported for web integration
- **Rate Limiting**: Built-in protection against abuse (100 requests/minute per IP)
- **Security Headers**: Enhanced security with proper HTTP headers
- **Performance Monitoring**: Request timing and processing metrics
- **Comprehensive Logging**: Detailed request/response logging for debugging
- **Real-time Status**: Live API server status monitoring with uptime information

## Setup

### 1. Enable the API

1. Open BijbelQuiz app
2. Go to **Settings** → **Local API**
3. Toggle **"Enable Local API"** to ON
4. Click **"Generate Key"** to create an API key
5. Optionally change the **API Port** (default: 7777)

### 2. API Key Management

- **Generate New Key**: Creates a new API key and invalidates the previous one
- **Key Format**: `bq_` followed by a 16-character alphanumeric string
- **Security**: Keep your API key secure and don't share it publicly

### 3. Network Access

The API server binds to `0.0.0.0` (all network interfaces), making it accessible from:
- Local machine: `http://localhost:7777`
- Local network: `http://[device-ip]:7777`
- External tools: Use your device's IP address

## Authentication

All API endpoints (except `/health`) require authentication using your API key.

### Authentication Methods

#### 1. Bearer Token (Recommended)
```bash
curl -H "Authorization: Bearer your-api-key" \
     http://localhost:7777/questions
```

#### 2. API Key Header
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/questions
```

### Error Response (Invalid/Missing Key)
```json
{
  "error": "Invalid or missing API key",
  "message": "Please provide a valid API key via Authorization header (Bearer token) or X-API-Key header",
  "timestamp": "2025-10-20T16:45:49.539Z"
}
```

## API Versioning

The BijbelQuiz API uses versioning to ensure backward compatibility and allow for future enhancements. The current version is **v1**.

### Base URL
```
http://localhost:7777/v1
```

All API endpoints are prefixed with the version number (`/v1`). This allows for future API versions to be introduced without breaking existing integrations.

### 1. Health Check
**GET** `/v1/health`

Check if the API server is running and healthy.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-20T16:45:49.539Z",
  "service": "BijbelQuiz API",
  "version": "v1",
  "uptime": "running"
}
```

**Usage:**
```bash
curl http://localhost:7777/v1/health
```

### 2. Get Questions
**GET** `/v1/questions`

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
  "difficulty": null,
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 45
}
```

**Examples:**
```bash
# Get 10 random questions
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/questions?limit=10

# Get questions from Genesis category
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/questions?category=Genesis&limit=5

# Get hard difficulty questions
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/questions?difficulty=4&limit=20
```

### 3. Get Questions by Category
**GET** `/v1/questions/{category}`

Get questions from a specific category.

**Path Parameters:**
- `category`: The category name (e.g., "Genesis", "Psalmen")

**Query Parameters:**
- `limit` (optional): Number of questions to return (default: 10, max: 50)
- `difficulty` (optional): Filter by difficulty level (1-5)

**Response:** Same format as `/v1/questions` endpoint

**Examples:**
```bash
# Get questions from Psalms
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/questions/Psalmen?limit=15

# Get easy questions from Proverbs
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/questions/Spreuken?difficulty=2
```

### 4. Get User Progress
**GET** `/v1/progress`

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
  },
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 12
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/progress
```

### 5. Get Game Statistics
**GET** `/v1/stats`

Retrieve current game statistics and performance metrics.

**Response:**
```json
{
  "score": 1250,
  "currentStreak": 7,
  "longestStreak": 15,
  "incorrectAnswers": 23,
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 8
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/stats
```

### 6. Get App Settings
**GET** `/v1/settings`

Retrieve current app settings and preferences.

**Response:**
```json
{
  "themeMode": "dark",
  "gameSpeed": "medium",
  "mute": false,
  "analyticsEnabled": true,
  "notificationEnabled": true,
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 15
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/settings
```

### 7. Get Star Balance
**GET** `/v1/stars/balance`

Retrieve the current star balance for the user.

**Response:**
```json
{
  "balance": 1250,
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 8
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/stars/balance
```

### 8. Add Stars
**POST** `/v1/stars/add`

Add stars to the user's balance with transaction logging.

**Request Body:**
```json
{
  "amount": 10,
  "reason": "Quiz completed",
  "lessonId": "lesson_1"
}
```

**Response:**
```json
{
  "success": true,
  "balance": 1260,
  "amount_added": 10,
  "reason": "Quiz completed",
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 15
}
```

**Usage:**
```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -H "X-API-Key: your-api-key" \
     -d '{"amount": 10, "reason": "Quiz completed", "lessonId": "lesson_1"}' \
     http://localhost:7777/v1/stars/add
```

### 9. Spend Stars
**POST** `/v1/stars/spend`

Spend stars from the user's balance with validation for sufficient funds.

**Request Body:**
```json
{
  "amount": 5,
  "reason": "Skip question",
  "lessonId": "lesson_1"
}
```

**Response:**
```json
{
  "success": true,
  "balance": 1255,
  "amount_spent": 5,
  "reason": "Skip question",
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 12
}
```

**Error Response (Insufficient Balance):**
```json
{
  "error": "Insufficient stars",
  "message": "Not enough stars in balance for this transaction",
  "current_balance": 3,
  "requested_amount": 10,
  "timestamp": "2025-10-20T16:45:49.539Z"
}
```

**Usage:**
```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -H "X-API-Key: your-api-key" \
     -d '{"amount": 5, "reason": "Skip question"}' \
     http://localhost:7777/v1/stars/spend
```

### 10. Get Star Transactions
**GET** `/v1/stars/transactions`

Retrieve star transaction history with optional filtering.

**Query Parameters:**
- `limit` (optional): Number of transactions to return (default: 50, max: 1000)
- `type` (optional): Filter by transaction type (`earned`, `spent`, `lesson_reward`, `refund`)
- `lessonId` (optional): Filter by lesson ID

**Response:**
```json
{
  "transactions": [
    {
      "id": "1634748549539",
      "timestamp": "2025-10-20T16:45:49.539Z",
      "type": "earned",
      "amount": 10,
      "reason": "Quiz completed",
      "lessonId": "lesson_1",
      "metadata": null
    },
    {
      "id": "1634748548547",
      "timestamp": "2025-10-20T16:45:48.547Z",
      "type": "spent",
      "amount": -5,
      "reason": "Skip question",
      "lessonId": "lesson_1",
      "metadata": null
    }
  ],
  "count": 2,
  "type_filter": null,
  "lesson_filter": null,
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 25
}
```

**Examples:**
```bash
# Get last 20 transactions
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/stars/transactions?limit=20

# Get only earned stars transactions
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/stars/transactions?type=earned&limit=50

# Get transactions for specific lesson
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/stars/transactions?lessonId=lesson_1
```

### 11. Get Star Statistics
**GET** `/v1/stars/stats`

Retrieve comprehensive star statistics and analytics.

**Response:**
```json
{
  "stats": {
    "totalTransactions": 156,
    "currentBalance": 1250,
    "totalEarned": 1450,
    "totalSpent": 200,
    "netTotal": 1250,
    "transactionsLast24h": 12,
    "transactionsLast7d": 45,
    "transactionsLast30d": 156,
    "averageTransactionAmount": 8.97
  },
  "timestamp": "2025-10-20T16:45:49.539Z",
  "processing_time_ms": 18
}
```

**Usage:**
```bash
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/stars/stats
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
- `413 Payload Too Large`: Request exceeds size limit (1MB)
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server-side error

### Enhanced Error Response Features

All error responses now include:
- **timestamp**: When the error occurred (ISO 8601 format)
- **processing_time_ms**: How long the request took before failing
- **valid_range/valid_values**: For validation errors, shows acceptable values

### Rate Limiting Error Response
```json
{
  "error": "Rate limit exceeded",
  "message": "Too many requests. Maximum 100 requests per minute allowed.",
  "retry_after": 60,
  "timestamp": "2025-10-20T16:45:49.539Z"
}
```

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

The API implements comprehensive rate limiting to prevent abuse and ensure fair usage:

### Limits
- **Maximum 100 requests per minute per IP address**
- **1MB maximum request payload size**
- **Rate limit window**: 1 minute (60 seconds)

### Behavior
- Requests are tracked per IP address
- Rate limit counters are automatically cleaned up every 5 minutes
- Health check endpoints (`/v1/health`) are exempt from rate limiting
- Rate-limited requests return `429 Too Many Requests` with retry information

### Headers
Rate limiting information is included in response headers:
- `X-RateLimit-Limit`: Maximum requests per minute
- `X-RateLimit-Remaining`: Remaining requests in current window
- `X-RateLimit-Reset`: Unix timestamp when the rate limit resets
- `Retry-After`: Seconds to wait before retrying (for rate-limited responses)

## Integration Examples

### Python Example
```python
import requests

API_KEY = "your-api-key-here"
BASE_URL = "http://localhost:7777/v1"

def get_questions(category=None, limit=10):
    headers = {"X-API-Key": API_KEY}
    params = {"limit": limit}
    if category:
        params["category"] = category

    response = requests.get(f"{BASE_URL}/questions", headers=headers, params=params)
    response.raise_for_status()
    data = response.json()
    print(f"Request processed in {data.get('processing_time_ms', 0)}ms")
    return data

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
const BASE_URL = "http://localhost:7777/v1";

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
        const errorData = await response.json().catch(() => ({}));
        throw new Error(`API error: ${response.status} - ${errorData.message || 'Unknown error'}`);
    }
    const data = await response.json();
    console.log(`Request processed in ${data.processing_time_ms}ms`);
    return data;
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
curl http://localhost:7777/v1/health

# Get 5 random questions
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/questions?limit=5

# Get questions from Matthew with Bearer token
curl -H "Authorization: Bearer your-api-key" \
     http://localhost:7777/v1/questions?category=Matteüs&limit=10

# Get user progress
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/progress

# Get game statistics
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/stats

# Get settings
curl -H "X-API-Key: your-api-key" \
     http://localhost:7777/v1/settings
```

## Troubleshooting

### Common Issues

1. **Connection Refused**
    - Ensure the API is enabled in BijbelQuiz settings
    - Check that the port (default: 7777) is not blocked by firewall
    - Verify the app is running and not in background
    - Try the new versioned URL: `http://localhost:7777/v1/health`

2. **Authentication Failed**
    - Ensure you're using the correct API key
    - Check that the API key hasn't been regenerated
    - Try both Bearer token and X-API-Key header methods
    - Verify you're using the correct versioned endpoints (`/v1/`)

3. **Rate Limit Exceeded (429 Error)**
    - Slow down your request rate (max 100 requests/minute per IP)
    - Implement retry logic with exponential backoff
    - Check the `Retry-After` header for wait time
    - Consider caching responses to reduce API calls

4. **No Questions Returned**
    - Check if questions are loaded in the BijbelQuiz app
    - Verify category names are spelled correctly
    - Try without category filter to see if questions are available
    - Check API logs for detailed error information

5. **Port Already in Use**
    - Change the API port in BijbelQuiz settings
    - Check what process is using the port: `netstat -tulpn | grep :7777`
    - On Windows: `netstat -ano | findstr :7777`

6. **Request Too Large (413 Error)**
    - Reduce request payload size (limit is 1MB)
    - Check if you're sending unnecessary data
    - Consider paginating large requests

7. **Invalid Parameter Values**
    - Check that difficulty is between 1-5
    - Ensure limit is between 1-50
    - Verify category names match exactly
    - Look for validation hints in error responses

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

### Enhanced Security Features

The API now includes several security improvements:

1. **Security Headers**: All responses include security headers to prevent common web vulnerabilities
2. **Request Size Limiting**: Maximum 1MB request payload to prevent abuse
3. **Rate Limiting**: Automatic protection against excessive requests
4. **Input Validation**: Comprehensive validation of all request parameters
5. **Error Information Limiting**: Error responses don't leak sensitive system information

### Security Headers Included
- `X-Content-Type-Options: nosniff` - Prevents MIME type sniffing
- `X-Frame-Options: DENY` - Prevents clickjacking attacks
- `X-XSS-Protection: 1; mode=block` - Enables XSS filtering
- `Content-Security-Policy` - Restricts resource loading
- `Referrer-Policy: strict-origin-when-cross-origin` - Controls referrer information

### Best Practices
1. **API Key Protection**: Keep your API key secure and don't commit it to version control
2. **Network Exposure**: The API is accessible from your local network - be aware of this when using on public WiFi
3. **Firewall Configuration**: Consider firewall rules if you need to restrict access to specific IP ranges
4. **Key Rotation**: Regularly regenerate your API key for enhanced security
5. **HTTPS Usage**: Always use HTTPS in production environments
6. **Monitor Rate Limits**: Be aware of rate limiting and implement retry logic with exponential backoff

## Performance

### Enhanced Performance Features

- **Response Time**: Typically <100ms for local requests with detailed timing metrics
- **Memory Usage**: Minimal additional memory usage when API is enabled
- **Concurrent Requests**: Supports multiple simultaneous requests with rate limiting
- **Caching**: Questions are cached in the BijbelQuiz app for fast retrieval
- **Request Optimization**: Automatic cleanup of rate limiting data every 5 minutes
- **Processing Metrics**: All responses include processing time for performance monitoring

### Performance Monitoring

Each API response includes:
- `processing_time_ms`: Time taken to process the request
- `timestamp`: When the response was generated
- Rate limiting headers for client-side optimization

### Best Practices for Performance
1. **Enable request caching** in your application to reduce API calls
2. **Monitor processing_time_ms** to identify slow endpoints
3. **Implement exponential backoff** for rate-limited requests
4. **Batch requests** when possible to reduce connection overhead

## Support

For API-related issues:
1. Check the troubleshooting section above
2. Verify your setup matches the documentation
3. Test with simple `curl` commands first
4. Check BijbelQuiz app logs for error details

## Changelog

### Version 1.1.2 (Latest)
- **Star Transaction System**: Complete star transaction management with history tracking
- **New Star Endpoints**: Added `/v1/stars/*` endpoints for balance, transactions, and statistics
- **Transaction Logging**: All star operations are logged with detailed metadata
- **Enhanced Analytics**: Comprehensive star statistics and transaction analytics
- **Improved Integration**: Better API integration with enhanced error handling

### Version 1.1.0
- **API Versioning**: All endpoints now use `/v1/` prefix for future compatibility
- **Rate Limiting**: Implemented 100 requests/minute per IP with automatic cleanup
- **Enhanced Security**: Added security headers, request size limiting, and input validation
- **Performance Monitoring**: Added processing time metrics to all responses
- **Improved Error Handling**: Enhanced error responses with timestamps and validation hints
- **Better Logging**: Comprehensive request/response logging with timing information
- **Input Validation**: Strict validation for all parameters with detailed error messages
- **Documentation Updates**: Updated all examples and added new troubleshooting section

### Version 1.0.0
- Initial API implementation
- Basic authentication and question endpoints
- Progress and statistics endpoints
- Settings endpoint for app configuration