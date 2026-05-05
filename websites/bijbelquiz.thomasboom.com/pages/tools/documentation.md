# Documentatie Vraagformaat

Dit document legt de structuur en het formaat van de vragen uit zoals gebruikt in de BijbelQuiz applicatie.

## Algemene Structuur

Elke vraag is een object met de volgende eigenschappen:

### Verplichte Eigenschappen

- `vraag` (string): De vraagtekst in het Nederlands
- `juisteAntwoord` (string): Het correcte antwoord
- `fouteAntwoorden` (array van strings): Lijst van onjuiste antwoorden (meestal 3)
- `moeilijkheidsgraad` (nummer): Moeilijkheidsniveau (1-5, waarbij 1 het makkelijkst is)
- `type` (string): Vraagtype (zie hieronder)
- `categories` (array van strings): Categorieën of bijbelboeken gerelateerd aan de vraag (momenteel leeg)
- `biblicalReference` (string of null): Bijbelreferentie voor de vraag (optioneel)

### Vraagtypen

1. `mc` - Meerkeuze: Vragen met meerdere antwoordopties
2. `fitb` - Invulvraag: Vragen waarbij een woord of zin moet worden ingevuld
3. `tf` - Waar/Niet Waar: Vragen met "Waar" of "Niet waar" als antwoord

### Voorbeelden

#### Meerkeuzevraag
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

#### Invulvraag
```json
{
  "vraag": "Op de 1e dag schiep God _____",
  "juisteAntwoord": "het licht",
  "fouteAntwoorden": ["de mens", "de planten", "de vissen"],
  "moeilijkheidsgraad": 1,
  "type": "fitb",
  "categories": [],
  "biblicalReference": "Genesis 1:4"
}
```

#### Waar/Niet Waar Vraag
```json
{
  "vraag": "God schiep de hemel en aarde in zeven dagen",
  "juisteAntwoord": "Niet waar",
  "moeilijkheidsgraad": 1,
  "type": "tf",
  "categories": [],
  "fouteAntwoorden": ["Waar"],
  "biblicalReference": "Genesis 2:2"
}
```

### Moeilijkheidsniveaus

Vragen worden gewaardeerd op een schaal van 1 tot 5:
- 1: Zeer makkelijk
- 2: Makkelijk
- 3: Gemiddeld
- 4: Moeilijk
- 5: Zeer moeilijk