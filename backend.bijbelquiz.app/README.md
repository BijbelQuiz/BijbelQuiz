# BijbelQuiz-backend

backend.bijbelquiz.app

## Inhoud

- [API](#api)
- [Vragen toevoegen](#vragen-toevoegen)
- [Vraagformaat](#vraagformaat)

## API

De API is beschikbaar via de volgende endpoints:
- `/api/version` - Geeft de huidige versie van de backend
- `/api/download` - Download de vragenlijst
- `/api/emergency` - Noodendpoint voor dringende zaken

## Vragen toevoegen

Bezoek `/add-questions` om vragen toe te voegen aan de database. Deze interface maakt gebruik van je browser's lokale opslag om vragen tijdelijk op te slaan totdat je ze downloadt als JSON-bestand.

## Vraagformaat

Voor informatie over het formaat van vragen, zie [format-documentation-nl.md](add-questions/format-documentation-nl.md).
