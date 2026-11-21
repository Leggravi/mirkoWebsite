#!/usr/bin/env bash
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(pwd)"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

error() {
  echo "ERROR: $*" >&2
  exit 1
}

if ! command_exists bundle; then
  error "Bundler ist nicht installiert. Bitte installiere die Abhängigkeiten mit 'bundle install'."
fi

if ! command_exists premailer; then
  error "Premailer ist nicht installiert. Bitte installiere es, z. B. mit 'gem install premailer'."
fi

HAVE_ZENITY=false
if command_exists zenity; then
  HAVE_ZENITY=true
fi

select_post_file() {
  if [[ "$HAVE_ZENITY" == true ]]; then
    zenity --file-selection \
      --title="Markdown-Post wählen" \
      --filename="$ROOT/_posts/" \
      --file-filter="Markdown-Dateien | *.md"
  else
    echo "Bitte gib den Pfad zur Markdown-Datei ein (z. B. _posts/2026-05-16-Back-to-Business.md):"
    read -r path
    printf '%s' "$path"
  fi
}

ask_input() {
  local title="$1"
  local prompt="$2"
  local default_text="${3:-}"
  if [[ "$HAVE_ZENITY" == true ]]; then
    local tmpfile
    tmpfile="$(mktemp)"
    printf '%s' "$default_text" > "$tmpfile"
    local result
    result="$(zenity --text-info --editable --filename="$tmpfile" --title="$title" --width=700 --height=360 2>/dev/null || true)"
    rm -f "$tmpfile"
    if [[ -z "$result" ]]; then
      printf '%s' "$default_text"
    else
      printf '%s' "$result"
    fi
  else
    echo "$prompt"
    echo "Gib mehrzeiligen Text ein. Beende mit einer Zeile, die nur einen Punkt enthält."
    local line
    local result=""
    while IFS= read -r line; do
      [[ "$line" == "." ]] && break
      result+="$line"$'\n'
    done
    if [[ -z "$result" ]]; then
      printf '%s' "$default_text"
    else
      printf '%s' "$result"
    fi
  fi
}

raw_source="${1:-}" 
if [[ -z "$raw_source" ]]; then
  raw_source="$(select_post_file)"
fi

if [[ -z "$raw_source" ]]; then
  error "Keine Datei ausgewählt."
fi

source_path="$raw_source"
if [[ "$source_path" != /* ]]; then
  source_path="$ROOT/$source_path"
fi

if [[ ! -f "$source_path" ]]; then
  query="$(basename "$raw_source" .md)"
  query_norm="$(printf '%s' "$query" | tr '[:upper:]' '[:lower:]' | tr ' _-' '   ' | tr -s ' ')"
  matches=()
  while IFS= read -r -d '' file; do
    name="$(basename "$file" .md)"
    norm="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | tr ' _-' '   ' | tr -s ' ')"
    if [[ "$norm" == *"$query_norm"* ]]; then
      matches+=("$file")
    fi
  done < <(find "$ROOT/_posts" -maxdepth 2 -type f -name '*.md' -print0)

  if [[ ${#matches[@]} -eq 1 ]]; then
    source_path="${matches[0]}"
  elif [[ ${#matches[@]} -gt 1 ]]; then
    echo "Mehrere Dateien gefunden, bitte wähle eine aus:"
    for i in "${!matches[@]}"; do
      printf '%s: %s\n' "$((i+1))" "${matches[i]}"
    done
    read -rp "Nummer auswählen: " choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || ((choice < 1 || choice > ${#matches[@]})); then
      error "Ungültige Auswahl."
    fi
    source_path="${matches[$((choice-1))]}"
  else
    error "Datei nicht gefunden: $source_path"
  fi
fi

source_path="$(realpath "$source_path")"
if [[ "$source_path" != "$ROOT"* ]]; then
  error "Die Datei muss innerhalb des Projektordners liegen: $ROOT"
fi

relative_source="${source_path#$ROOT/}"

original_filename="$(basename "$relative_source" .md)"
if [[ "$relative_source" == _posts/* ]]; then
  original_filename="${original_filename#[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-}"
  original_filename="${original_filename// /-}"
fi
slug="$(basename "$relative_source" .md)"
if [[ "$relative_source" == _posts/* ]]; then
  slug="${slug#[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-}"
  slug="${slug// /-}"
  slug="$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/-/g; s/-\+/-/g; s/^-\|-$//g')"
fi

email_preview="$(ask_input "E-Mail Vorschau" "Optional: Vorschau-Text für E-Mail-Clients (Preheader). Lass leer, um den Standardtext zu verwenden." "Hallo {{Name}}, ein neuer Rundbrief von Mirko ist da: Brasilien, Rückkehr nach Deutschland, persönliche Eindrücke und neue Projekte. Viel Spaß beim Lesen!")"
email_opening="$(ask_input "E-Mail Eröffnung" "Optional: Einleitenden Text, der vor dem Beitrag eingefügt wird. Lass leer, um den Standardtext zu verwenden." "Nice, dass du meinen Rundbrief abonniert hast! Hier ein neues Update mit Geschichten, Bildern und persönlichen Eindrücken.")"
email_closing="$(ask_input "E-Mail Abschluss" "Optional: Abschließenden Text, der nach dem Beitrag eingefügt wird. Lass leer, um keinen zusätzlichen Abschlusstext einzufügen.")"

if [[ -z "$email_preview" ]]; then
  email_preview='Neues Update vom Rundbrief – direkt für dich.'
fi
if [[ -z "$email_opening" ]]; then
  email_opening='Nice, dass du meinen Rundbrief abonniert hast! Hier ein neues Update.'
fi

tmp_build="$(mktemp -d "$ROOT/tmp-email-build.XXXX")"
trap 'rm -rf "$tmp_build"' EXIT

output_filename="${slug}_email.html"
output_path="$ROOT/../$output_filename"

mkdir -p "$(dirname "$output_path")"

if [[ "$relative_source" == _posts/* ]]; then
  source_date="$(grep -m1 '^date:' "$source_path" | sed -E 's/^date:[[:space:]]*["'\'' ]?([^"'\'']*)["'\'' ]?/\1/' | cut -c1-10)"
  if [[ -n "$source_date" ]]; then
    year="${source_date:0:4}"
    month="${source_date:5:2}"
    day="${source_date:8:2}"
  else
    year="${relative_source:7:4}"
    month="${relative_source:12:2}"
    day="${relative_source:15:2}"
  fi
  date_prefix="${year}-${month}-${day}"
  original_permalink="/$year/$month/$day/$original_filename.html"
else
  date_prefix="$(date +%F)"
  original_permalink=""
fi

temp_post="$ROOT/_posts/${date_prefix}-email-tmp-${slug}-$(date +%s).md"
permalink="/__email-preview/${slug}.html"

export EMAIL_PREVIEW="$email_preview"
export EMAIL_OPENING="$email_opening"
export EMAIL_CLOSING="$email_closing"
export EMAIL_PERMALINK="$permalink"
export ORIGINAL_PERMALINK="$original_permalink"

python3 - "$source_path" "$temp_post" <<'PY'
import os
from pathlib import Path
import json
import sys

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
text = src.read_text(encoding='utf-8')
if not text.startswith('---'):
    raise SystemExit('Fehler: Die Markdown-Datei muss mit YAML-Frontmatter beginnen.')

lines = text.splitlines()
end = None
for i in range(1, len(lines)):
    if lines[i].strip() == '---':
        end = i
        break
if end is None:
    raise SystemExit('Fehler: Kein schließender Frontmatter-Trenner gefunden.')

meta = lines[1:end]
body = '\n'.join(lines[end+1:])

fields = {
    'layout': 'email',
    'permalink': os.environ['EMAIL_PERMALINK']
}
if os.environ.get('ORIGINAL_PERMALINK'):
    original = os.environ['ORIGINAL_PERMALINK']
    if original:
        fields['original_url'] = original
if os.environ.get('EMAIL_PREVIEW'):
    fields['email_preview'] = os.environ['EMAIL_PREVIEW']
if os.environ.get('EMAIL_OPENING'):
    fields['email_opening'] = os.environ['EMAIL_OPENING']
if os.environ.get('EMAIL_CLOSING'):
    fields['email_closing'] = os.environ['EMAIL_CLOSING']

new_meta = []
handled = set()
for line in meta:
    stripped = line.strip()
    if ':' in stripped:
        key = stripped.split(':', 1)[0].strip()
    else:
        key = None
    if key in fields:
        value = fields.pop(key)
        new_meta.append(f'{key}: {json.dumps(value)}')
        handled.add(key)
    elif key in {'email_preview', 'email_opening', 'email_closing'}:
        continue
    else:
        new_meta.append(line)

for key, value in fields.items():
    new_meta.append(f'{key}: {json.dumps(value)}')

if not any(line.strip().startswith('layout:') for line in meta):
    pass

output = '---\n' + '\n'.join(new_meta) + '\n---\n' + body

dst.write_text(output, encoding='utf-8')
PY
echo "Baue Seite ..."
cd "$ROOT"
bundle exec jekyll build --destination "$tmp_build/_site"

generated_html="$tmp_build/_site${permalink}"
if [[ ! -f "$generated_html" ]]; then
  error "Der generierte E-Mail-HTML wurde nicht gefunden: $generated_html"
fi

premailer "$generated_html" > "$output_path"

rm -f "$temp_post"

echo "E-Mail-Datei erfolgreich erstellt: $output_path"
if command_exists xdg-open; then
  echo "Öffne Vorschau in deinem Standardbrowser..."
  xdg-open "$output_path" >/dev/null 2>&1 || true
fi
