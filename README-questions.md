# Questions Format Documentation

This document explains the structure and format of the questions in `assets/questions-nl-sv.json`.

## Overall Structure

The file contains a JSON array where each element is a question object with the following properties:

### Common Properties

- `vraag` (string): The question text in Dutch
- `juisteAntwoord` (string): The correct answer
- `fouteAntwoorden` (array of strings): List of incorrect answers (usually 3)
- `moeilijkheidsgraad` (number): Difficulty level (1-5, where 1 is easiest)
- `type` (string): Question type (see below)
- `categories` (array of strings): Categories or Bible books related to the question
- `biblicalReference` (string or null): Bible reference for the question

### Question Types

1. `mc` - Multiple Choice: Questions with several answer options
2. `fitb` - Fill in the Blank: Questions where a word or phrase needs to be filled in
3. `tf` - True/False: Questions where the answer is either "Waar" (true) or "Niet waar" (false)

### Examples

#### Multiple Choice Question
```json
{
  "vraag": "Hoeveel Bijbelboeken heeft het Nieuwe Testament?",
  "juisteAntwoord": "27",
  "fouteAntwoorden": ["26", "66", "39"],
  "moeilijkheidsgraad": 3,
  "type": "mc",
  "categories": [],
  "biblicalReference": null
}
```

#### Fill in the Blank Question
```json
{
  "vraag": "Op de 1e dag schiep God...",
  "juisteAntwoord": "het licht",
  "fouteAntwoorden": ["de mens", "de planten", "de vissen"],
  "moeilijkheidsgraad": 1,
  "type": "fitb",
  "categories": ["Genesis"],
  "biblicalReference": "Genesis 1:4"
}
```

#### True/False Question
```json
{
  "vraag": "Goed schiep de hemel en aarde in zeven dagen",
  "juisteAntwoord": "Niet waar",
  "moeilijkheidsgraad": 1,
  "type": "tf",
  "categories": ["Genesis"],
  "fouteAntwoorden": ["Waar"],
  "biblicalReference": "Genesis 2:2"
}
```

### Categories

Questions may be tagged with categories that typically correspond to Bible books or major themes (e.g., "Genesis", "Matteüs", "Richteren", "Psalmen").

### Difficulty Levels

Questions are rated on a scale from 1 to 5:
- 1: Very easy
- 2: Easy
- 3: Medium
- 4: Hard
- 5: Very hard

# Error Reporting System

## Overview
The BijbelQuiz app includes a centralized error reporting system that allows users and developers to report bugs directly to a Supabase database. This system captures technical details, user context, and additional information to help diagnose and fix issues.

## Architecture
- **ErrorReportingService**: The main service that handles reporting errors to Supabase
- **ErrorReport**: Data model for storing error information
- **Supabase Integration**: Errors are stored in a dedicated `error_reports` table
- **Settings Integration**: Users can access the bug report form from the settings screen

## How to Use

### From Code
```dart
import 'package:bijbelquiz/services/error_reporting_service.dart';

// Report a simple error
await ErrorReportingService().reportSimpleError(
  message: 'Something went wrong',
  type: AppErrorType.network,
  userMessage: 'Could not connect to the server',
  questionId: '12345',
  additionalInfo: {'screen': 'HomeScreen', 'userAction': 'tapButton'},
);

// Report a full AppError object
final appError = AppError(
  type: AppErrorType.validation,
  technicalMessage: 'Validation failed',
  userMessage: 'Please enter a valid value',
);
await ErrorReportingService().reportError(
  appError: appError,
  questionId: '12345',
  additionalInfo: {'inputValue': 'invalid'},
);
```

### Through UI
Users can access the bug reporting form from the Settings screen:
1. Navigate to Settings
2. Tap on "Report an issue" or "Bug rapporteren"
3. Fill out the bug report form
4. Submit the report

## Database Schema
The error reports are stored in a Supabase table with the following columns:
- `id`: Unique identifier for the error report
- `user_id`: ID of the user who reported the error (optional)
- `error_type`: Type of error (e.g., network, validation, etc.)
- `error_message`: Technical error message
- `user_message`: User-friendly error message
- `error_code`: Optional error code
- `stack_trace`: Full stack trace when available
- `context`: Additional context as JSON string
- `question_id`: ID of the question associated with the error (optional)
- `additional_info`: Additional information as JSON string
- `timestamp`: When the error was reported
- `device_info`: Information about the user's device
- `app_version`: Version of the app
- `build_number`: Build number of the app

## Integration with Existing Error Handling
The new error reporting system integrates with the existing error handling system:
- All calls to `ErrorHandler.showError()` and `ErrorHandler.showErrorDialog()` now automatically report errors to Supabase
- The existing error handling behavior is preserved (snackbars, dialogs)
- Additional parameters have been added to pass question IDs and additional context

## Supabase Setup
The database migration file (`database_supabase/migrations/001_create_error_reports_table.sql`) contains the SQL to create the required table structure including indexes and RLS policies.