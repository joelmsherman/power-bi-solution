#!/usr/bin/env bash
# setup.sh - Initialize a new Power BI solution from this template.
#
# Renames the {{ProjectName}} scaffold (the .pbip, the report and the semantic
# model), gives both items fresh Fabric logical IDs, and writes the SQL Server
# connection parameters. The themes are already staged in the report;
# /report-theme stamps the client's brand into them at step 2.
#
# Usage: ./setup.sh <ProjectName> [DatabaseName] [ServerName]

set -euo pipefail

PROJECT_NAME="${1:?Usage: ./setup.sh <ProjectName> [DatabaseName] [ServerName]}"
DB_NAME="${2:-$PROJECT_NAME}"
SERVER_NAME="${3:-localhost}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -d "src/{{ProjectName}}.SemanticModel" ]]; then
  echo "Nothing to do: src/{{ProjectName}}.SemanticModel/ is gone, so setup.sh has already run." >&2
  exit 1
fi

# PBIP folder names must match ^[\w-]+$ or Power BI silently ignores them.
if [[ ! "$PROJECT_NAME" =~ ^[A-Za-z0-9_-]+$ ]]; then
  echo "ProjectName must contain only letters, digits, '_' and '-' (got '$PROJECT_NAME')." >&2
  exit 1
fi

new_guid() {
  if command -v uuidgen >/dev/null; then uuidgen | tr 'A-Z' 'a-z'
  else python3 -c 'import uuid; print(uuid.uuid4())'; fi
}

# BSD sed (macOS) requires an argument to -i; GNU sed treats it as the suffix.
# Neither is portable, and `sed -i` on a symlink replaces the link with a real
# file — which would quietly break CLAUDE.md -> AGENTS.md. Do the edit in place
# through the resolved path instead.
subst() {  # subst <file> -e <expr> [-e <expr>...]
  local file="$1"; shift
  local tmp="${file}.setup-tmp.$$"
  sed "$@" "$file" > "$tmp"
  cat "$tmp" > "$file"        # `cat >` writes through a symlink; `mv` would replace it
  rm -f "$tmp"
}

echo "Initializing Power BI solution: $PROJECT_NAME"
echo "  Database: $DB_NAME"
echo "  Server:   $SERVER_NAME"
echo ""

# Rename the project, report and semantic model
mv "src/{{ProjectName}}.Report" "src/${PROJECT_NAME}.Report"
mv "src/{{ProjectName}}.SemanticModel" "src/${PROJECT_NAME}.SemanticModel"
mv "src/{{ProjectName}}.pbip" "src/${PROJECT_NAME}.pbip"

# Replace {{ProjectName}} tokens in the project source and in the agent instructions.
# AGENTS.md is the canonical file; CLAUDE.md is a symlink to it and must stay one.
while IFS= read -r f; do
  subst "$f" -e "s/{{ProjectName}}/${PROJECT_NAME}/g"
done < <(find src -type f \( -name "*.pbip" -o -name "*.pbir" -o -name "*.pbism" -o -name "*.tmdl" -o -name ".platform" \))

subst AGENTS.md -e "s/{{ProjectName}}/${PROJECT_NAME}/g"

# Fresh logical IDs, so two projects made from this template never collide in a workspace
subst "src/${PROJECT_NAME}.Report/.platform" -e "s/{{ReportLogicalId}}/$(new_guid)/"
subst "src/${PROJECT_NAME}.SemanticModel/.platform" -e "s/{{SemanticModelLogicalId}}/$(new_guid)/"

# Update connection parameters in expressions.tmdl
EXPR_FILE="src/${PROJECT_NAME}.SemanticModel/definition/expressions.tmdl"
subst "$EXPR_FILE" -e "s/\"localhost\"/\"${SERVER_NAME}\"/g" -e "s/\"${PROJECT_NAME}\"/\"${DB_NAME}\"/g"

# Sanity check: the symlinks must have survived.
if [[ ! -L CLAUDE.md ]]; then
  echo "WARNING: CLAUDE.md is no longer a symlink to AGENTS.md. Restore it with:" >&2
  echo "  rm CLAUDE.md && ln -s AGENTS.md CLAUDE.md" >&2
fi
if [[ ! -L .claude/skills ]]; then
  echo "WARNING: .claude/skills is no longer a symlink to .agents/skills. Restore it with:" >&2
  echo "  rm -rf .claude/skills && ln -s ../.agents/skills .claude/skills" >&2
fi

echo "Project '$PROJECT_NAME' initialized successfully."
echo ""
echo "  Semantic Model: src/${PROJECT_NAME}.SemanticModel/"
echo "  Report:         src/${PROJECT_NAME}.Report/  (themes staged; /report-theme brands them at step 2)"
echo "  Engagement:     _project_/                   (deleted once the report ships)"
echo ""
echo "Launch Claude Code ('claude') and accept the marketplace trust prompt, then:"
echo ""
echo "  0. Carry the intake artifacts into _project_/0-intake/, then run discovery"
echo "  1. Plan the product with /prd-creator"
echo "  2. Stamp the client's brand with /report-theme"
echo "  3. Get the prototype approved and commit it as _project_/3-prototype/mockset.html"
echo "  4. Build the semantic model under src/${PROJECT_NAME}.SemanticModel/"
echo "  5. Audit it, then run scripts/validate.sh"
echo "  6. Deploy the model and scaffold its DAX tests (te test init)"
echo "  7-8. Build the report milestone by milestone (_project_/4-milestones/)"
echo "  9. Review, validate and publish the report, 10. Document"
