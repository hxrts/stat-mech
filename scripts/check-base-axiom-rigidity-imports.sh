#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomRigidity.lean"

echo "[check-base-axiom-rigidity-imports] checking imports in $FILE"

if rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.Faithful\.' "$FILE" | rg -v 'Faithful\.BaseAxiomCompactness' >/dev/null; then
  echo "[check-base-axiom-rigidity-imports] FAIL: rigidity module imports non-base faithful wrappers" >&2
  exit 1
fi

echo "[check-base-axiom-rigidity-imports] PASS"
