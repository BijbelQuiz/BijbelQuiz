External API Risk Assessment - Summary
Overall Risk: MEDIUM - Good security foundation but external AI dependencies need attention.

APIs Identified (7 total):
Google Gemini AI - MEDIUM risk

Theme generation for BijbelQuiz app
✅ Good reliability, ⚠️ User data sent to Google
OpenRouter AI - HIGH risk

Bible chat for BijbelBot app
❌ Sensitive religious content sent externally
❌ No data retention guarantees
Online Bible API - LOW risk

Primary Bible content source
✅ Public content only, ✅ Has fallback
PostHog Analytics - MEDIUM risk

User behavior tracking
⚠️ Tracks usage patterns, ✅ User opt-out available
Custom Backend API - LOW risk

Self-hosted questions API
✅ Full control, ✅ Local caching fallback
Bible API (fallback) - LOW risk

Backup Bible content
✅ Public content only
Stripe Payments - LOW risk

Payment processing (configured only)
✅ Industry standard security
Key Risks:
Privacy: OpenRouter AI receives sensitive religious conversations
Reliability: Third-party Bible API could fail without warning
Data: External AI services may log/process user content
Immediate Actions Required:
Review OpenRouter AI necessity - Consider local alternative
Add privacy warnings for AI features
Monitor API availability regularly
Implement API health checks
Risk Mitigation Status:
✅ HTTPS encryption on all APIs
✅ API key management proper
✅ Fallback mechanisms for Bible content
❌ No monitoring for external API health
❌ Privacy review needed for AI services
Recommendation: Reduce external AI dependencies or implement local processing to lower overall risk to LOW.