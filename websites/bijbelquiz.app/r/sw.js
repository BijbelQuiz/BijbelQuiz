// Service worker for caching redirect pages

const CACHE_NAME = 'bijbelquiz-redirects-v1';
const urlsToCache = [
  '/r/redirect.html',
  '/r/discord.html',
  '/r/donate.html',
  '/r/email.html',
  '/r/index.html',
  '/r/kwebler.html',
  '/r/mastodon.html',
  '/r/signal-contact.html',
  '/r/signal-group.html'
];

// Install event - cache all redirect pages
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(urlsToCache);
      })
  );
});

// Fetch event - serve cached content when offline
self.addEventListener('fetch', event => {
  // Only handle requests to the redirect pages
  if (event.request.url.includes('/r/')) {
    event.respondWith(
      caches.match(event.request)
        .then(response => {
          // Return cached version or fetch from network
          return response || fetch(event.request);
        })
        .catch(() => {
          // Fallback to the unified redirect page
          return caches.match('/r/redirect.html');
        })
    );
  }
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});