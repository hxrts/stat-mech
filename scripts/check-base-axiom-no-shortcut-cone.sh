#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful"

echo "[check-base-axiom-no-shortcut-cone] scanning base-axiom imports"

if rg -n --glob 'BaseAxiom*.lean' '^import StatMech\.ContinuumField\.NavierStokes\.(Global\.ClayEndgame|HardStep\.Definitive\.TrueTorusClayBUnconditional|HardStep\.Definitive\.TrueTorusFluxBarrier)' "$TARGET_DIR" >/dev/null; then
  echo "[check-base-axiom-no-shortcut-cone] FAIL: found banned shortcut-module imports in base-axiom cone" >&2
  exit 1
fi

echo "[check-base-axiom-no-shortcut-cone] PASS"
