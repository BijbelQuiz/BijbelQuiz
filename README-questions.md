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