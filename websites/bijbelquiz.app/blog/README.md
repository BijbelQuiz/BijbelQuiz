# BijbelQuiz Blog

Deze directory bevat de blog voor de BijbelQuiz website. Hier kunnen maintainers blogposts schrijven en publiceren.

## Hoe voeg je een nieuwe blogpost toe?

### Stap 1: Gebruik de template
1. Kopieer het bestand `template.html`
2. Hernoem het naar je blogpost ID (bijv. `mijn-nieuwe-post.html`)
3. Plaats het in de `posts/` directory

### Stap 2: Bewerk de template
Vervang alle placeholders in `[HAKJE]` met je eigen inhoud:
- `[TITEL VAN JE BLOGPOST]` - De titel van je post
- `[JE NAAM]` - Je naam als auteur
- `[DATUM - bijv. 15 januari 2025]` - Publicatiedatum
- `[LEESTIJD - bijv. 5 min lezen]` - Geschatte leestijd
- `[INTRODUCTIE PARAGRAAF]` - Inleidende tekst
- Voeg je eigen inhoud toe in de secties

### Stap 3: Voeg de post toe aan de blog index
Bewerk `index.html` en voeg je nieuwe post toe aan de `blogPosts` array in JavaScript:

```javascript
{
    id: 'mijn-nieuwe-post',
    title: 'Mijn Nieuwe Blogpost',
    excerpt: 'Korte samenvatting van je post...',
    date: '2025-01-20',
    author: 'Je Naam',
    readTime: '3 min lezen'
}
```

### Stap 4: Test je post
1. Open `index.html` in je browser om te zien of de post in de lijst staat
2. Klik op de link om je volledige post te bekijken
3. Controleer of alles correct werkt

## Best practices
- Gebruik duidelijke, beschrijvende titels
- Schrijf een aantrekkelijke inleiding om lezers te boeien
- Gebruik korte paragrafen voor betere leesbaarheid
- Voeg afbeeldingen toe als dat relevant is
- Controleer spelling en grammatica
- Test op verschillende apparaten (desktop, mobiel)

## Voorbeeld structuur
```
blog/
├── index.html          # Hoofdpagina met lijst van alle posts
├── template.html       # Template voor nieuwe posts
├── README.md          # Deze instructies
└── posts/
    ├── welkom-bij-bijbelquiz.html
    ├── mijn-nieuwe-post.html
    └── ...
```

## Technische details
- Alle blogposts gebruiken dezelfde CSS styling als de rest van de site
- De blog is responsive en werkt op alle apparaten
- Posts worden automatisch gesorteerd op datum (nieuwste eerst)
- Gebruik Nederlandse taal voor consistentie

## Hulp nodig?
Als je vragen hebt over het toevoegen van blogposts, neem dan contact op met het development team.