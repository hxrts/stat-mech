#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"

echo "[check-decisive-completion-no-nonempty-seeds] checking decisive completion seed assumptions"

if rg -n "Nonempty \\(DecisiveCompletionSeed" "$FILE" >/dev/null; then
  echo "[check-decisive-completion-no-nonempty-seeds] FAIL: decisive completion still uses Nonempty seed-family assumptions" >&2
  rg -n "Nonempty \\(DecisiveCompletionSeed" "$FILE" >&2
  exit 1
fi

echo "[check-decisive-completion-no-nonempty-seeds] PASS"
