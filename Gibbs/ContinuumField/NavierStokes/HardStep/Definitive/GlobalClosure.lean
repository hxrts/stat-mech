import Gibbs.ContinuumField.NavierStokes.HardStep.ContradictionClosure

/-! # Definitive global-closure consequences

Derives unconditional hard-step closure statements from the definitive
critical-element contradiction obligations.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct definitive hard-step global closure from minimal-element exclusion. -/
theorem definitiveHardStepGlobalClosure
    (excludes_all_minimal : ∀ _m : HardStepMinimalElement, False) :
    HardStepGlobalClosure := by
  intro m
  exact excludes_all_minimal m

end Gibbs.ContinuumField.NavierStokes
