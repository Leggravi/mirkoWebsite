# Holz, Herz & Himmel (Mirko) — Website (Jekyll)

Kurz: persönliche Blog-/Rundbrief-Website (Jekyll) mit Beiträgen, "raw" Entwürfen und einigen Hilfsseiten. Dieses README dokumentiert die aktuelle Struktur, erklärt wichtige Dateien/Skripte, nennt generierte Inhalte und gibt konkrete Vorschläge zum Aufräumen.

Inhalt
- Projektübersicht
- Schnellstart (lokal)
- Wichtige Dateien & Funktionen (mit Links)
- Ordner-Übersicht & Bedeutung
- Hinweise zu generierten Dateien (_site)
- Vorschläge / To‑do für Aufräumen und Neuorganisation
- Deployment & Kontakt

---

Projektübersicht
---------------

Diese Website ist ein Jekyll-basiertes Blog/Portfolio mit Blogposts in `_posts/`, statischen Seiten, Entwürfen in `raw/` und vielen Hilfsdateien unter `assets/`. Einige Dateien im Repo sind Kopien oder generierte Artefakte unter `_site/`. Ziel: klar strukturieren, überflüssige Dateien identifizieren, README ergänzen und langfristig gut wartbar machen.

Schnellstart (lokal)
--------------------
Voraussetzung: Ruby + Bundler (für Jekyll) oder Docker. Die Seite wurde mit Jekyll erzeugt (siehe generierte `_site/`).

-Lokales Testen mit Jekyll (klassisch):
  ```sh
  bundle install
  bundle exec jekyll serve --livereload
  ```
  (Konfiguration in [_config.yml](_config.yml).)

- Ohne Ruby: Die bereits erzeugten Seiten liegen in `_site/` — können direkt in einem Static-Server geöffnet werden.

Wichtige Dateien & zentrale Funktionen
-------------------------------------

- Layouts:
  - [`_layouts/default.html`][ _layouts/default.html ] — Hauptlayout: Navigation, Theme-Switcher, TOC-Generator, Sternenhimmel/Partikel-Animationen und Notification-Banner-Logik. Enthält zentrale JS-Funktionen wie:
    - [`switchTheme`]( _layouts/default.html ) — wechselt Themes und speichert Auswahl.
    - [`startStarfield`]( _layouts/default.html ) / [`stopStarfield`]( _layouts/default.html ) / [`handleStarfieldTheme`]( _layouts/default.html ) — Sternenhimmel-Canvas-Animation (Theme "game").
    - [`startPollen`]( _layouts/default.html ) / [`stopPollen`]( _layouts/default.html ) / [`handlePollenTheme`]( _layouts/default.html ) — Pollenpartikel (Theme "forest").
    - TOC-Generator / Scroll-Marker — erzeugt Inhaltsverzeichnis aus H2/H3 innerhalb `.content`.
  - [`_layouts/email.html`][ _layouts/email.html ] — E-Mail-kompatibles Layout (Kopie-Note, Footer).
  - [`_layouts/brief.html`][ _layouts/brief.html ] — "Brief" (druckfreundlich / PDF) Layout.

- Posts & Inhalte:
  - [`_posts/`]( _posts/ ) — veröffentlichte Blogeinträge (Datum-getriggerte Markdown-Dateien).
  - [`raw/`]( raw/ ) — Rohtexte / Entwürfe (Markdown / HTML). Diese Dateien sind nützlich, gehören jedoch ggf. nach `_posts` / `pages` verschoben oder archiviert.

- Assets:
  - [`assets/js/notifications.js`]( assets/js/notifications.js ) — zentrale Notifications-Definition (window.NOTIFICATIONS).
  - [`assets/css/style.css`]( assets/css/style.css ) — Hauptstylesheet (verlinkt im Layout).
  - `/assets/img/` — Bilder (Profil, SEO, etc.).

- PWA / Service Worker:
  - [`manifest.json`]( manifest.json )
  - [`service-worker.js`]( service-worker.js )

- Sonstiges:
  - [`Spenden.md`]( Spenden.md ) — Spenden-Info-Seite.
  - [`about.md`], [`about.html`] — "Über mich" Seiten (Achte auf doppelte Inhalte).
  - [`warten.md`], [`warten.html`] — Countdown-Vorbereitungsseite (eine Datei inkludiert die andere).

Generierte Dateien / `_site`
---------------------------
- [`_site/`]( _site/ ) — erzeugte (build) Dateien von Jekyll. Enthält HTML-Kopien aller Seiten. Diese sind nicht quellcode-relevant und sollten nicht committen werden, außer es ist bewusst für GitHub Pages nötig. Beispiele:
  - `_site/index.html` — erzeugte Startseite
  - `_site/about/index.html` — erzeugte About-Seite
  - `_site/raw/` — gerenderte Kopien von `raw/`-Inhalten
- Empfehlung: Entferne `_site/` aus Commits (füge `.gitignore`-Eintrag hinzu), solange du nicht absichtlich statische Dateien versionierst.

Ordner-Übersicht & Bedeutung
----------------------------
- Root:
  - `_config.yml` — Jekyll-Konfiguration (Base URL, Plugins, etc.).
  - `Gemfile` — Ruby Gems für Jekyll.
  - `manifest.json`, `service-worker.js` — PWA-Einstellungen.
- Content:
  - `_posts/` — veröffentlichte Blogposts (Datum-basiert).
  - `raw/` — Rohentwürfe, Notizen, E-Mail-Versionen (z. T. Doppelungen zu `_posts/`).
  - `blog/`, `notes.html`, `about.html` — statische Seiten; prüfen auf Duplikate (z. B. `about.md` vs `about.html`).
- UI / assets:
  - `assets/js/notifications.js` — Notifications-Liste.
  - `assets/css/` — Styles (zentrale Stelle für Theme-Styles).
- Sonstige Ordner:
  - `Lego/`, `games/`, `my-status-corner/`, `löschen/` — vermutlich Projekte/Altdaten. Archivieren oder löschen, wenn unnötig.
  - `.github/`, `.obsidian/` — Repo- / Private-Notes; `.obsidian/` ggf. lokal halten und ignorieren.

Konkrete Red Flags (Dinge, die durcheinander wirken)
----------------------------------------------------
- Viele generierte Dateien in `_site/` sind im Repo; das führt zu Doppelarbeit. Prüfe `.gitignore`.
- Doppelte Inhalte: z. B. `about.md` und `about.html` + `_site/about/index.html`. Wähle ein Source-Format (MD oder HTML).
- Rohordner `raw/` enthält Inhalte, die sowohl als `_posts/` als auch als E‑Mail-Vorlage gerendert werden — konsolidieren.
- Dateien mit Sonderzeichen (z. B. `𝙈𝙚𝙞𝙣 2. 𝙍𝙪𝙣𝙙𝙗𝙧𝙞𝙚𝙛!.html`) erschweren Automatisierung und URL-Stabilität — umbenennen.
- `assets/js/notifications.js` wird sowohl in Quell-Layouts als auch in `_site/` kopiert — halte nur eine Quelle in `assets/`.

Empfohlene Aufräum‑ & Umstrukturierungsschritte (kurz)
-----------------------------------------------------
1. Git: Erstelle Branch "cleanup/readme" für Änderungen.
2. .gitignore: Stelle sicher, dass `_site/` und `.obsidian/` ignoriert werden.
3. Inhalte konsolidieren:
   - Move fertige Posts nach `_posts/`.
   - Raw-Entwürfe in `raw/drafts/` verschieben; nur bei Veröffentlichung nach `_posts`.
   - Entferne oder archiviere veraltete Ordner (`löschen/`, alte Projekte).
4. Einheitliche Dateinamen: keine Sonderzeichen in Dateinamen; Use slugified US-ASCII names.
5. Assets: Trenne JS per Verantwortung:
   - `assets/js/main.js` — TOC, theme-switch, cookie helpers (von `_layouts/default.html` auslagern).
   - `assets/js/starfield.js`, `assets/js/pollen.js` — Animationen auslagern.
   - `assets/js/notifications.js` bleibt zentrale Quelle.
   - Verlinke die Dateien im Layout statt alles inline.
6. Layouts:
   - `_layouts/default.html` entkernen: JS in `assets/js/` auslagern, HTML-Komponenten in `_includes/`.
   - Erstelle `_includes/topbar.html`, `_includes/sidebar.html`, `_includes/notifications.html`.
7. Readability: Ersetze inline styles im HTML (viele `style="..."`) durch Klassen im CSS.
8. Tests / Lint: Optional: kleine Scripts in `scripts/` für Strukturprüfung (z. B. find unslugged filenames).

Praktische Hinweise / Beispiele
-------------------------------
- Notifications:
  - Quelle: [`assets/js/notifications.js`]( assets/js/notifications.js )
  - Anzeige-Logik: in [`_layouts/default.html`][ _layouts/default.html ] (Variable `window.NOTIFICATIONS` wird ausgewertet).
- Theme / Animation:
  - Theme-Wechsel-Funktion: [`switchTheme`]( _layouts/default.html )
  - Animation-Funktionen (`startStarfield`, `startPollen`) sind im Layout eingebettet — empfehlenswert: auslagern nach `assets/js/`.

Cleanup-Checklist (konkrete Commits)
------------------------------------
- [ ] .gitignore: add `_site/`, `.DS_Store`, `.env`, `.obsidian/`
- [ ] Move/rename: `𝙈𝙚𝙞𝙣 2. 𝙍𝙪𝙣𝙙𝙗𝙧𝙞𝙚𝙛!.html` → `raw/rundbrief-2.html`
- [ ] Consolidate `about.md` / `about.html` → keep one source (prefer `_pages/about.md`)
- [ ] Extract JS from `_layouts/default.html` → `assets/js/{main,starfield,pollen}.js`
- [ ] Create `_includes/` for topbar/sidebar/footer/notifications
- [ ] Move published pages to `_posts/` or `pages/` consistently
- [ ] Remove `_site/` from repository or move to `gh-pages` branch if required

Deployment
----------
- GitHub Pages mit Jekyll: Wenn du GitHub Pages verwendest, kannst du entweder die Source-Branch (Jekyll-Build on GitHub) oder eine `gh-pages`-Branch mit fertigem `_site/` deployen. Empfehlung: committe nur Quellcode; aktiviere GitHub Pages auf der Repo-Einstellung und lasse GitHub bauen.
- Falls du aktuell `_site/` committest, überlege Umzug zu Quell-Only und GitHub-Building (sauberer Repo).

Nützliche Dateien (Direkte Links)
--------------------------------
- Layouts:
  - [_layouts/default.html](_layouts/default.html)
  - [_layouts/email.html](_layouts/email.html)
  - [_layouts/brief.html](_layouts/brief.html)
- Content:
  - `_posts/` directory: [`_posts/`]( _posts/ )
  - `raw/` drafts: [`raw/`]( raw/ )
  - `Spenden.md` — Spenden-Seite: [`Spenden.md`]( Spenden.md )
  - `about.md` / `about.html`: [`about.md`]( about.md ), [`about.html`]( about.html )
  - `warten.md` / `warten.html`: [`warten.md`]( warten.md ), [`warten.html`]( warten.html )
- Assets:
  - [`assets/js/notifications.js`]( assets/js/notifications.js )
  - [`assets/css/style.css`]( assets/css/style.css ) (falls vorhanden)
- Config:
  - [`_config.yml`]( _config.yml )
  - [`Gemfile`]( Gemfile )
- PWA:
  - [`manifest.json`]( manifest.json )
  - [`service-worker.js`]( service-worker.js )

Kontakt / Weiteres
------------------
Wenn du willst, kann ich:
- das Layout aufräumen und JS in Dateien auslagern,
- eine vorgeschlagene, bereinigte Ordnerstruktur anlegen (Beispiele für _includes / assets / pages),
- die oben genannte Cleanup-Checklist in konkrete Git-Commit-Schritte aufteilen.

Viel Erfolg beim Aufräumen — wenn du möchtest, erstelle ich auf Wunsch direkt die reorganisierte Struktur und die ausgelagerten JS-Dateien.