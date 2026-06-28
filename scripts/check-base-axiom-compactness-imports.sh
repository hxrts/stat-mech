#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/BaseAxiomCompactness.lean"

echo "[check-base-axiom-compactness-imports] checking imports in $FILE"

if rg -n '^import StatMech\.ContinuumField\.NavierStokes\.Faithful\.' "$FILE" | rg -v 'Faithful\.BaseAxiomAnalysis' >/dev/null; then
  echo "[check-base-axiom-compactness-imports] FAIL: compactness module imports non-base faithful wrappers" >&2
  exit 1
fi

echo "[check-base-axiom-compactness-imports] PASS"
