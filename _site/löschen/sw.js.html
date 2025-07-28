const CACHE_VERSION = "v1.3"; // ⬅ Bei Änderungen erhöhen!
const OFFLINE_URL = "/offline.html";

const CACHE_FILES = [
  "/",
  "/index.html",
  "/offline.html",
  "/assets/icon-192.png",
  "/assets/icon-512.png",
  "/main.css",
  // ggf. weitere statische Seiten hinzufügen
];

self.addEventListener("install", event => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_VERSION).then(cache => {
      return cache.addAll(CACHE_FILES);
    })
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(name => name !== CACHE_VERSION)
          .map(name => caches.delete(name))
      );
    })
  );
});

self.addEventListener("fetch", event => {
  if (event.request.method !== "GET") return;

  event.respondWith(
    fetch(event.request)
      .then(response => {
        return response;
      })
      .catch(() => {
        return caches.match(event.request).then(response => {
          return response || caches.match(OFFLINE_URL);
        });
      })
  );
});
