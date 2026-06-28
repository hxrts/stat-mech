#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful"
SOURCE="$TARGET/BaseAxiomRigidity.lean"

echo "[check-rigidity-carrier-isolated] checking rigidity carrier isolation"

if [[ ! -f "$SOURCE" ]]; then
  echo "[check-rigidity-carrier-isolated] FAIL: missing source file $SOURCE" >&2
  exit 1
fi

if rg -n --glob '*.lean' "BaseAxiomPrimitiveRigidity" "$TARGET" >/dev/null; then
  echo "[check-rigidity-carrier-isolated] FAIL: BaseAxiomPrimitiveRigidity should be fully removed from faithful route" >&2
  rg -n --glob '*.lean' "BaseAxiomPrimitiveRigidity" "$TARGET" >&2
  exit 1
fi

echo "[check-rigidity-carrier-isolated] PASS"
