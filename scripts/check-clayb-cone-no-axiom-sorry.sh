#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT/Gibbs/ContinuumField/NavierStokes"

echo "[check-clayb-cone-no-axiom-sorry] scanning $TARGET_DIR"

if rg -n --glob '*.lean' '^\s*(axiom|sorry)\b' "$TARGET_DIR"; then
  echo "[check-clayb-cone-no-axiom-sorry] FAIL: found axiom/sorry in Navier-Stokes cone"
  exit 1
fi

echo "[check-clayb-cone-no-axiom-sorry] PASS"

