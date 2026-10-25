#!/usr/bin/env bash
# Render a self-contained HTML file to PDF using the puppeteer-cached headless Chrome.
# usage: render-pdf.sh <input.html> [output.pdf]   (output defaults to input path with .pdf)
set -euo pipefail

HTML_ABS="$(realpath "${1:?usage: render-pdf.sh <input.html> [output.pdf]}")"
PDF_ABS="$(realpath -m "${2:-${HTML_ABS%.html}.pdf}")"

newest_match() { # print the version-newest path matching the glob, or nothing
  local matches=()
  while IFS= read -r line; do matches+=("$line"); done < <(compgen -G "$1" | sort -V)
  [[ ${#matches[@]} -gt 0 ]] && printf '%s\n' "${matches[-1]}"
}

BIN="$(newest_match "$HOME/.cache/puppeteer/chrome-headless-shell/*/chrome-headless-shell-linux64/chrome-headless-shell" || true)"
[[ -x "${BIN:-}" ]] || BIN="$(newest_match "$HOME/.cache/puppeteer/chrome/*/chrome-linux64/chrome" || true)"

if [[ ! -x "${BIN:-}" ]]; then
  echo "No cached headless Chrome found under ~/.cache/puppeteer/." >&2
  echo "Fallback: open ${HTML_ABS} in a browser (light theme) and use Print > Save as PDF -> ${PDF_ABS}" >&2
  exit 1
fi

"$BIN" --headless --no-sandbox --disable-gpu --no-pdf-header-footer \
  --virtual-time-budget=15000 --print-to-pdf="$PDF_ABS" "file://${HTML_ABS}" 2>/dev/null

if [[ -s "$PDF_ABS" ]]; then
  echo "Wrote ${PDF_ABS}"
else
  echo "Render produced an empty file at ${PDF_ABS}" >&2
  exit 1
fi
