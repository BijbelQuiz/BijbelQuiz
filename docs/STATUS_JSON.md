# Status JSON Documentation

This document describes the public `status.json` endpoint for the BijbelQuiz status site.

**Endpoint**
- `https://status.bijbelquiz.thomasboom.com/status.json`

**Purpose**
- Provide a machine-readable snapshot of current service health.
- Show only currently active events.
- Offer lightweight integration for monitoring and status widgets.

**Response**
- Content-Type: `application/json`
- Cache-Control: `no-store`
- Always computed on request.

**Top-level fields**
- `status`: Overall health. One of `operational`, `degraded`, `major`.
- `title`: Human label for `status`.
- `summary`: Short description. Can be empty when fully operational.
- `updatedAt`: ISO-8601 timestamp when the snapshot was generated.
- `windowDays`: Rolling window size for uptime calculation.
- `uptimePercent`: Uptime percentage for the window, rounded to 3 decimals.
- `events`: Array of active events only. Empty when there are no ongoing events.

**Event fields**
- `id`: Event identifier.
- `title`: Event title.
- `description`: Event description.
- `type`: `incident` or `maintenance`.
- `severity`: `minor`, `major`, or `critical`.
- `status`: Event status. Currently `ongoing` for all returned events.
- `impact`: `app` or `website`.
- `startsAt`: ISO-8601 timestamp for start time.
- `endsAt`: ISO-8601 timestamp for end time or `null` if not set.

**Notes**
- Only active events are included in `events`.
- If there are no active events, `events` is an empty array.
- `summary` can be an empty string when all systems are operational.
- If `impact` was not set on older events, it defaults to `app` in the API.

**Example**
```json
{
  "status": "degraded",
  "title": "Degraded Performance",
  "summary": "Some services are slower than usual. Updates below.",
  "updatedAt": "2026-02-05T15:22:11.141Z",
  "windowDays": 90,
  "uptimePercent": 99.982,
  "events": [
    {
      "id": "j57eg7a3kxwqxgbz0bq1zcx7fh80jezb",
      "title": "Login vertraging",
      "description": "Aanmeldingen zijn traag door extra databasebelasting.",
      "type": "incident",
      "severity": "minor",
      "status": "ongoing",
      "impact": "app",
      "startsAt": "2026-02-05T13:12:00.000Z",
      "endsAt": null
    }
  ]
}
```
