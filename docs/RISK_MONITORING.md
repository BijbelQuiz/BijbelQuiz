# API Inventory for BijbelQuiz Project

## Question Editor Interface (`/question-editor/*`)

**VULNERABLE:** Public access to development interface, path traversal risks

**IMPROVE:** Add authentication, implement file upload validation, add audit logging

## Google Gemini AI API (external)

**VULNERABLE:** API key management, prompt injection risks

**IMPROVE:** Implement secure key storage, add prompt filtering, add usage monitoring

## Online Bible API (external)

**VULNERABLE:** No authentication, search query exposure

**IMPROVE:** Add input sanitization, implement content filtering, add privacy controls
