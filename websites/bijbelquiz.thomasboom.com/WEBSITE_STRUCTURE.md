# Website Structure

This document describes the new structure of the BijbelQuiz website for better maintainability and organization.

## Directory Structure

```
website/
├── assets/                      # Static assets
│   ├── components/              # Reusable HTML components
│   │   └── footer.html
│   ├── css/                     # Stylesheets
│   │   └── theme.css
│   └── images/                  # Images and screenshots
 ├── pages/                       # Organized pages
 │   ├── account/                 # Account-related pages
 │   │   ├── verwijderen.html (account deletion page)
 │   │   └── geregistreerd.html (account registered page)
 │   ├── email/                   # Email templates
 │   │   └── index.html
 │   ├── guides/                  # Installation guides (instructie in Dutch)
 │   │   ├── android.html
 │   │   ├── api.html
 │   │   ├── index.html
 │   │   ├── migratie.html
 │   │   └── windows.html
 │   ├── terms/                   # Terms and conditions
 │   │   └── index.html
 │   ├── thank-you.html           # Thank you page (dankjewel in Dutch)
 │   └── tools/                   # Tools and utilities (vraag-editor in Dutch)
 │       ├── index.html           # Question editor
 │       ├── documentation.md
 │       ├── script.js
 │       ├── status.js
 │       └── style.css
├── [root files]                 # Main pages at root level
│   ├── index.html
│   ├── download.html
│   ├── faq.html
│   ├── pers.html
│   ├── links.html
│   ├── invite.html
│   ├── score.html
│   ├── gen.html
│   ├── 404.html
│   ├── robots.txt
│   ├── sitemap.xml
│   └── vercel.json
```

## URL Structure

### New URLs (Dutch)

All primary clean URLs are in Dutch:

- **Terms & Privacy**: `/pages/terms/index.html` (clean URL: `/algemene-voorwaarden`)
- **Email**: `/pages/email/index.html` (clean URL: `/e-mail`)
- **Guides**: `/pages/guides/` (clean URL: `/instructie`)
  - Android: `/pages/guides/android.html` (clean URL: `/instructie/android`)
  - Windows: `/pages/guides/windows.html` (clean URL: `/instructie/windows`)
  - API: `/pages/guides/api.html` (clean URL: `/instructie/api`)
  - Migration: `/pages/guides/migratie.html` (clean URL: `/instructie/migratie`)
- **Account**: `/pages/account/`
  - Delete: `/pages/account/verwijderen.html` (clean URL: `/account/verwijderen`)
  - Registered: `/pages/account/geregistreerd.html` (clean URL: `/account/geregistreerd`)
- **Tools**: `/pages/tools/` (clean URL: `/vraag-editor`)
- **Thank You**: `/pages/thank-you.html` (clean URL: `/dankjewel`)

### Backward Compatible Redirects

All old URLs are automatically redirected to new locations:

- `/algemene-voorwaarden.html` → `/algemene-voorwaarden`
- `/privacy.html` → `/algemene-voorwaarden`
- `/email.html` → `/e-mail`
- `/dankjewel.html` → `/dankjewel`
- `/instructie/` → `/instructie`
- `/instructie/android` → `/instructie/android`
- `/instructie/windows` → `/instructie/windows`
- `/instructie/api` → `/instructie/api`
- `/instructie/migratie` → `/instructie/migratie`
- `/account/delete` → `/account/verwijderen`
- `/account/registered` → `/account/geregistreerd`
- `/question-editor` → `/vraag-editor`

### English URLs Redirecting to Dutch

All English URLs redirect to their Dutch equivalents:

- `/privacy` → `/algemene-voorwaarden`
- `/terms` → `/algemene-voorwaarden`
- `/voorwaarden` → `/algemene-voorwaarden`
- `/email` → `/e-mail`
- `/thank-you` → `/dankjewel`
- `/guides` → `/instructie`
- `/guides/android` → `/instructie/android`
- `/guides/windows` → `/instructie/windows`
- `/guides/api` → `/instructie/api`
- `/guides/migration` → `/instructie/migratie`
- `/guides/migratie` → `/instructie/migratie`
- `/tools` → `/vraag-editor`
- `/tools/editor` → `/vraag-editor`

### Alternative Clean URLs

- `/terms` → `/pages/terms/index.html`
- `/voorwaarden` → `/pages/terms/index.html`
- `/guides` → `/pages/guides/index.html`
- `/guides/migration` → `/pages/guides/migratie.html`
- `/tools` → `/pages/tools/`
- `/tools/editor` → `/pages/tools/`

## External Redirects

The following URLs redirect to external services:

- `/discord` → Discord server
- `/donate` → Buy Me a Coffee
- `/doneer` → Buy Me a Coffee (Dutch)
- `/kwebler` → Kwebler profile
- `/mastodon` → Mastodon profile
- `/bluesky` → Bluesky profile
- `/pixelfed` → Pixelfed profile
- `/signal-contact` → Signal contact
- `/signal-group` → Signal group
- `/tevredenheidsrapport` → Formbricks satisfaction survey
- `/status` → Status page
- `/nooki` → Nooki profile
- `/playstore` → Google Play Store
- `/play` → Play app
- `/speel` → Play app (Dutch)
- `/github` → GitHub repository
- `/vragenlijst` → Question form

## Asset References

All HTML files now use the new asset paths:

- Stylesheets: `/assets/css/theme.css`
- Components: `/assets/components/footer.html`
- Images: `/assets/images/`

## Migration Notes

1. **All old URLs continue to work** through redirects in `vercel.json`
2. **Update new content** to use the new URL structure
3. **Internal links** have been automatically updated
4. **SEO URLs** (canonical, OG tags) have been updated for pages
5. **Sitemap** includes all new URLs
6. **Robots.txt** allows crawling of new structure while blocking assets/tools

## Benefits of New Structure

1. **Logical organization**: Pages are grouped by function
2. **Better scalability**: Easy to add new pages within categories
3. **Maintainability**: Clear separation of concerns
4. **Backward compatibility**: No broken links for users
5. **SEO-friendly**: Clean URLs with redirects
6. **Asset management**: Centralized assets folder

## Adding New Pages

1. **Determine the category**: Choose appropriate folder (account, guides, tools, etc.)
2. **Create the file**: Add to the appropriate subfolder
3. **Update vercel.json**: Add clean URL redirect if needed
4. **Update sitemap.xml**: Add to sitemap
5. **Update robots.txt**: Allow path if needed
6. **Use proper asset paths**: `/assets/css/theme.css`, `/assets/components/footer.html`

## Testing

After deployment, test: following:

1. All old URLs redirect correctly to Dutch clean URLs
2. New Dutch clean URLs work as expected (`/algemene-voorwaarden`, `/e-mail`, `/instructie`, etc.)
3. English URLs redirect to Dutch equivalents (`/terms` → `/algemene-voorwaarden`, `/guides` → `/instructie`, etc.)
4. External redirects work
5. Internal links use clean Dutch URLs, not raw paths
6. Assets load correctly
7. SEO pages are accessible with correct canonical URLs
