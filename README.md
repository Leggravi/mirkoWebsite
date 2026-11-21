# Holz, Herz & Himmel

Die persönliche Website von Mirko. Sie basiert auf Jekyll und enthält Blogbeiträge, statische Seiten und die dafür verwendeten Layouts und Dateien.

## Lokal starten

### Voraussetzungen

- Ruby 3.x
- Bundler

Prüfe im Terminal, ob beides verfügbar ist:

```sh
ruby --version
bundle --version
```

Falls ein Befehl nicht gefunden wird, installiere Ruby und Bundler für dein Betriebssystem und öffne danach ein neues Terminal.

Unter Ubuntu oder Debian geht das zum Beispiel so:

```sh
sudo apt update
sudo apt install ruby-full ruby-bundler build-essential
```

### Erster Start

Führe die Befehle im Projektordner aus:

```sh
bundle install
./starten
```

`./starten` startet Jekyll mit Live-Neuladen. Falls die Gems noch fehlen, versucht das Skript zuerst `bundle install` auszuführen. Alternativ kannst du Jekyll direkt starten:

```sh
bundle exec jekyll serve --livereload
```

Öffne anschließend <http://127.0.0.1:4000/> im Browser. Änderungen an Seiten und Beiträgen werden automatisch neu gebaut. Zum Beenden im Terminal `Ctrl+C` drücken.

**Wenn `bundle` oder `ruby` nicht gefunden wird:** Das ist ein fehlendes Ruby/Bundler-Setup, kein Fehler der Website. Installiere zuerst Ruby und Bundler; `bundle install` kann ohne diese Programme nicht laufen.

## Website bauen

```sh
bundle exec jekyll build
```

Jekyll schreibt die fertige Website nach `_site/`. Dieser Ordner wird automatisch erzeugt und ist nicht der Ort, an dem du Inhalte bearbeiten solltest.

## Wo finde ich was?

- `_posts/` – veröffentlichte Blogbeiträge
- `index.md`, `about.html`, `warten.html` und weitere Dateien im Projektordner – Seiten der Website
- `_layouts/` – Vorlagen für Seiten, E-Mails und Druckansichten
- `assets/` – Bilder, Schriften, CSS und JavaScript
- `_config.yml` – Jekyll-Einstellungen
- `Gemfile` und `Gemfile.lock` – benötigte Ruby-Pakete und deren Versionen
- `generate-email.sh` – Hilfsskript zum Erstellen einer E-Mail aus einem Beitrag

Die Datei [`arbeitsnotizen.md`](arbeitsnotizen.md) enthält ältere persönliche Arbeitsnotizen. Sie wird zum Starten oder Bauen der Website nicht benötigt.

zusätzlich
http://127.0.0.1:4000/Jungscharfreizeit/2027.html
http://127.0.0.1:4000/Lego/25/Videos.html