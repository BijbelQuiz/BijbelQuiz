# Ollama Cloud Setup voor BijbelBot

Deze handleiding legt uit hoe je Ollama's cloud API configureert voor gebruik met de BijbelBot app.

## Vereisten

- Flutter SDK
- Internet verbinding
- Ollama account en API key

## Installatie en Setup

### Stap 1: Verkrijg een API Key

1. Ga naar [https://ollama.com](https://ollama.com)
2. Maak een account aan of log in
3. Ga naar Settings > API Keys
4. Genereer een nieuwe API key
5. Kopieer de API key

### Stap 2: Configureer de API Key

1. Open het `.env` bestand in de `bijbelbot` directory
2. Voeg je API key toe:
   ```
   OLLAMA_API_KEY=jouw_api_key_hier
   ```
3. Sla het bestand op

### Stap 3: Test de Configuratie

De BijbelBot app zal automatisch:
- **API Endpoint**: `https://ollama.com/api/chat`
- **Model**: `gpt-oss:120b`
- **Authentication**: Bearer token met je API key

## Probleemoplossing

### Veelvoorkomende Fouten

**"Ongeldige API key"**
- Controleer of je API key correct is gekopieerd in het `.env` bestand
- Verkrijg een nieuwe key van https://ollama.com/settings/keys
- Zorg ervoor dat er geen extra spaties zijn

**"Model niet gevonden"**
- Controleer of `gpt-oss:120b` beschikbaar is op https://ollama.com
- Het model kan tijdelijk niet beschikbaar zijn

**"Connection error"**
- Controleer je internetverbinding
- De Ollama cloud service kan tijdelijk offline zijn

**"JSON parsing error"**
- Dit is opgelost in de laatste versie van de code
- Herstart de app na het updaten

### Test de API Direct

Test je API key direct:

```bash
curl https://ollama.com/api/chat \
  -H "Authorization: Bearer $OLLAMA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-oss:120b",
    "messages": [{
      "role": "user",
      "content": "Hello, how are you?"
    }],
    "stream": false
  }'
```

## Configuratie

De BijbelBot gebruikt automatisch:
- **API Endpoint**: `https://ollama.com/api/chat`
- **Model**: `gpt-oss:120b`
- **Authentication**: Bearer token met je API key

## Beschikbare Cloud Modellen

Volgens de Ollama documentatie zijn deze cloud modellen beschikbaar:
- `deepseek-v3.1:671b-cloud`
- `gpt-oss:20b-cloud`
- `gpt-oss:120b-cloud`
- `kimi-k2:1t-cloud`
- `qwen3-coder:480b-cloud`

Voor directe API toegang gebruik je de modellen zonder `-cloud` suffix.

## BijbelBot Gebruik

1. Zorg ervoor dat je API key correct is geconfigureerd
2. Start de BijbelBot app
3. Stel vragen in het Nederlands over de Bijbel
4. De app zal automatisch verbinding maken met Ollama's cloud API

Voorbeelden van vragen:
- "Leg de gelijkenis van de verloren zoon uit"
- "Wat zegt de Bijbel over vergeving?"
- "Wie waren de discipelen van Jezus?"

## Ondersteuning

Bij problemen:
1. Controleer je API key in het `.env` bestand
2. Test je API key met de curl command hierboven
3. Controleer de BijbelBot logs voor specifieke foutmeldingen
4. Controleer de Ollama status op https://status.ollama.com