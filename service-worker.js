---
layout: null
permalink: /service-worker.js
---

const CACHE_NAME = 'mirko-cache-v1';
const OFFLINE_URL = '{{ "/offline.html" | relative_url }}';

const urlsToCache = [
  '{{ "/" | relative_url }}',
  '{{ "/assets/css/style.scss" | relative_url }}',
  '{{ "/assets/img/mirko.jpg" | relative_url }}',
  OFFLINE_URL,
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request)
        .catch(() => caches.match(OFFLINE_URL))
    );
  } else {
    event.respondWith(
      caches.match(event.request)
        .then(response => response || fetch(event.request))
    );
  }
});

// Cache-Reset über Nachricht
self.addEventListener('message', event => {
  if (event.data === 'clear-cache') {
    caches.keys().then(keys => keys.forEach(k => caches.delete(k)));
  }
});