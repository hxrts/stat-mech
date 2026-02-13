#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FACADE="$ROOT/Gibbs/ContinuumField/NavierStokes.lean"
REPORT="$ROOT/scripts/report-clayb-dependency-cone.sh"
FREEZE="$ROOT/scripts/freeze-clayb-checkpoint.sh"

echo "[check-navier-final-no-shortcut-route] checking final-route shortcut isolation"

for f in "$FACADE" "$REPORT" "$FREEZE"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-navier-final-no-shortcut-route] FAIL: missing file $f" >&2
    exit 1
  fi
done

if rg -n '^import Gibbs\.ContinuumField\.NavierStokes\.HardStep\.Definitive\.TrueTorusClayBUnconditional' "$FACADE" >/dev/null; then
  echo "[check-navier-final-no-shortcut-route] FAIL: facade re-imports retired shortcut module" >&2
  exit 1
fi

if rg -n 'clayBStatement_unconditional_no_bridge|TrueTorusClayBUnconditional' "$REPORT" "$FREEZE" >/dev/null; then
  echo "[check-navier-final-no-shortcut-route] FAIL: report/freeze scripts still point at retired unconditional shortcut route" >&2
  rg -n 'clayBStatement_unconditional_no_bridge|TrueTorusClayBUnconditional' "$REPORT" "$FREEZE" >&2
  exit 1
fi

TARGETS=(
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/Final.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/BaseAxiomCompletion.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/ClassicalEquivalence.lean"
  "$ROOT/Gibbs/ContinuumField/NavierStokes/HardStep/Definitive/ClayB.lean"
)

for f in "${TARGETS[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-navier-final-no-shortcut-route] FAIL: missing file $f" >&2
    exit 1
  fi
done

if rg -n 'clayBDefinitive|clayBStatement_unconditional_no_bridge|unresolvedClayBGlobalClosureLemma_replaced_unconditional|TrueTorusClayBUnconditional' "${TARGETS[@]}" >/dev/null; then
  echo "[check-navier-final-no-shortcut-route] FAIL: retired shortcut tokens appear in final-route files" >&2
  rg -n 'clayBDefinitive|clayBStatement_unconditional_no_bridge|unresolvedClayBGlobalClosureLemma_replaced_unconditional|TrueTorusClayBUnconditional' "${TARGETS[@]}" >&2
  exit 1
fi

echo "[check-navier-final-no-shortcut-route] PASS"
