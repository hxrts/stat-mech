#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"

echo "[check-decisive-global-no-threshold-closure-shortcut] checking decisive global threshold-chain bridge routing"

if [[ ! -f "$FILE" ]]; then
  echo "[check-decisive-global-no-threshold-closure-shortcut] FAIL: missing file $FILE" >&2
  exit 1
fi

if ! rg -n "decisiveSpine_global_closure_from_threshold_minimal_chain" "$FILE" >/dev/null; then
  echo "[check-decisive-global-no-threshold-closure-shortcut] FAIL: missing threshold-chain closure route token in decisive global bridge" >&2
  exit 1
fi

if rg -n "decisiveSpine_definitive_chain_nonempty_of_threshold_minimal_chain" "$FILE" >/dev/null; then
  echo "[check-decisive-global-no-threshold-closure-shortcut] FAIL: found retired threshold-to-definitive chain bridge in decisive global module" >&2
  exit 1
fi

echo "[check-decisive-global-no-threshold-closure-shortcut] PASS"
