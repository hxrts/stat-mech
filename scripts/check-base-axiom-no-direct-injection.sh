#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILES=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomGlobal.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
)

echo "[check-base-axiom-no-direct-injection] scanning base-axiom endpoint files"

for f in "${FILES[@]}"; do
  if rg -n 'vel\s*:=\s*fun _ =>|press\s*:=\s*fun _ =>|dvel\s*:=\s*fun _ =>' "$f" >/dev/null; then
    echo "[check-base-axiom-no-direct-injection] FAIL: found direct formula injection in $f" >&2
    exit 1
  fi
done

echo "[check-base-axiom-no-direct-injection] PASS"
