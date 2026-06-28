import Lake
open Lake DSL

/-! # Stat Mech Lean Package

Lake build definition for the StatMech verification library.
Mean-field theory meets multiparty session types.

Uses shared mathlib from ../lean_common/mathlib4 to avoid rebuilding.
-/

package statMech

-- Use shared local mathlib installation (with pre-built artifacts)
require mathlib from "../lean_common/mathlib4"
-- Effects spatial system from the local telltale repo
require telltale from "../telltale/lean"

/-- Main library for mean-field session types formalization. -/
@[default_target]
lean_lib StatMech where
  globs := #[`StatMech.*]
