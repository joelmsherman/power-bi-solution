#!/usr/bin/env bash
# validate.sh - The pre-deploy gate for the semantic model and the report.
#
# Cross-platform (Linux, WSL, macOS, Windows Git Bash). On WSL, pbir runs as the
# Windows pbir.exe through interop, since pbir has no Linux build. Runs, in order:
#   1. PBIP structure       validate_pbip.py from the pbip plugin
#   2. Model metadata       te validate
#   3. Model BPA            te bpa run, against src/.bpa/bpa-rules-semanticmodel.json
#   4. Report structure     pbir validate
#   5. Report BPA           pbir bpa run (pbir's built-in rule set)
#
# A missing tool is reported and its checks are skipped, so the script still
# tells you what it could check; the exit code is non-zero if anything failed
# or was skipped. Pass --allow-skips to exit 0 when only skips occurred.
#
# Usage: scripts/validate.sh [--allow-skips]

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
cd "$ROOT"

ALLOW_SKIPS=0
[[ "${1:-}" == "--allow-skips" ]] && ALLOW_SKIPS=1

shopt -s nullglob
models=(src/*.SemanticModel)
reports=(src/*.Report)
shopt -u nullglob
if [[ ${#models[@]} -ne 1 || ${#reports[@]} -ne 1 ]]; then
  echo "Expected exactly one src/*.SemanticModel and one src/*.Report, found ${#models[@]} and ${#reports[@]}." >&2
  exit 2
fi
MODEL="${models[0]}"
REPORT="${reports[0]}"
RULES="src/.bpa/bpa-rules-semanticmodel.json"

failed=()
skipped=()

step() { printf '\n== %s\n' "$1"; }
run() {  # run <label> <command...>
  local label="$1"; shift
  if "$@"; then echo "   ok: $label"; else echo "   FAILED: $label"; failed+=("$label"); fi
}
skip() { echo "   skipped: $1 ($2)"; skipped+=("$1"); }

# The pbip plugin's validator lives in the Claude Code plugin cache; take the
# newest installed copy.
find_validator() {
  local base="$HOME/.claude/plugins"
  find "$base" -path '*pbip/skills/pbip/scripts/validate_pbip.py' 2>/dev/null | sort -V | tail -n1
}

step "1. PBIP structure"
VALIDATOR="$(find_validator)"
if [[ -n "$VALIDATOR" ]] && command -v python3 >/dev/null; then
  run "pbip structure" python3 "$VALIDATOR" src --no-pbir-cli --quiet
else
  skip "pbip structure" "pbip plugin or python3 not found; enable the pbip plugin in Claude Code"
fi

step "2-3. Semantic model ($MODEL)"
if command -v te >/dev/null; then
  run "te validate" te validate --model "$MODEL"
  run "te bpa" te bpa run --rules "$RULES" --fail-on error --model "$MODEL"
else
  skip "te validate" "te not on PATH; see README > Requirements > Tabular Editor CLI"
  skip "te bpa" "te not on PATH"
fi

# pbir ships for Windows and macOS only. On WSL, use the Windows build through
# interop (pbir.exe on PATH), which needs a Windows path to the report.
PBIR=""; REPORT_ARG="$REPORT"
if command -v pbir >/dev/null; then
  PBIR=pbir
elif command -v pbir.exe >/dev/null && command -v wslpath >/dev/null; then
  PBIR=pbir.exe; REPORT_ARG="$(wslpath -w "$REPORT")"
fi

step "4-5. Report ($REPORT)"
if [[ -n "$PBIR" ]]; then
  run "pbir validate" "$PBIR" validate "$REPORT_ARG"
  if [[ -f "$REPORT/definition/report.json" ]]; then
    run "pbir bpa" "$PBIR" bpa run "$REPORT_ARG" --fail-on error
  else
    skip "pbir bpa" "no definition/report.json yet; the report foundation milestone creates it"
  fi
else
  skip "pbir validate" "pbir not found; uv tool install pbir-cli (on WSL: install it on Windows, see README)"
  skip "pbir bpa" "pbir not found"
fi

printf '\n== Summary\n'
join() { local IFS=","; echo "$*" | sed 's/,/, /g'; }
echo "   failed:  ${#failed[@]}${failed[*]:+ ($(join "${failed[@]}"))}"
echo "   skipped: ${#skipped[@]}${skipped[*]:+ ($(join "${skipped[@]}"))}"

if [[ ${#failed[@]} -gt 0 ]]; then exit 1; fi
if [[ ${#skipped[@]} -gt 0 && $ALLOW_SKIPS -eq 0 ]]; then exit 3; fi
exit 0
