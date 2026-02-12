#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineGlobal.lean"

echo "[check-decisive-spine-global-derived] checking global layer"

for pattern in \
  "decisiveSpine_global_critical_control_direct" \
  "decisiveSpine_global_critical_control_from_data" \
  "decisiveSpine_global_critical_control" \
  "decisiveSpine_global_extension_direct" \
  "decisiveSpine_global_extension_from_data" \
  "decisiveSpine_global_extension" \
  "decisiveSpine_global_smoothness_persistence_direct" \
  "decisiveSpine_global_smoothness_persistence_from_data" \
  "decisiveSpine_global_smoothness_persistence" \
  "decisiveSpine_no_direct_injection_policy"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-global-derived] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n 'vel\s*:=\s*fun _ =>|press\s*:=\s*fun _ =>|dvel\s*:=\s*fun _ =>' "$FILE" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: found direct formula injection in decisive global file" >&2
  exit 1
fi

if rg -n "BaseAxiomPrimitiveExtensionWitness|extension_hypotheses" "$FILE" >/dev/null; then
  echo "[check-decisive-spine-global-derived] FAIL: found legacy extension-witness plumbing in decisive-spine global file" >&2
  exit 1
fi

echo "[check-decisive-spine-global-derived] PASS"
