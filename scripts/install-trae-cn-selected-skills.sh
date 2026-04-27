#!/usr/bin/env bash
set -euo pipefail

# Installs the recommended skills from this repo into Trae CN global skills.
# Safe to re-run.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

AGENT="trae-cn"

SKILLS=(
  # Local-first workflow
  "to-prd-local"
  "to-issues-local"
  "triage-issue-local"
  "request-refactor-plan-local"
  "qa-local"
  "work-item-triage"

  # Design / quality (non-GitHub)
  "tdd"
  "improve-codebase-architecture"
  "design-an-interface"
  "domain-model"
  "ubiquitous-language"
  "zoom-out"
  "git-guardrails-claude-code"
)

ARGS=()
for s in "${SKILLS[@]}"; do
  ARGS+=("-s" "$s")
done

echo "[install] repo: $ROOT_DIR"
echo "[install] agent: $AGENT"
echo "[install] skills: ${#SKILLS[@]}"

# Use --copy to ensure multi-file skill directories (like tdd/) are installed fully.
# Use -y for non-interactive runs.
npx --yes skills@latest add . -g -a "$AGENT" -y --copy "${ARGS[@]}"

echo "[install] done"
