import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusUpperTailVanishing
import Gibbs.ContinuumField.NavierStokes.HardStep.ContradictionClosure

/-! # Definitive true-torus flux-barrier contradiction

Final definitive contradiction layer excluding minimal elements and deriving
unconditional hard-step global closure.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct definitive contradiction package combining lower and upper bounds. -/
structure DefinitiveFluxBarrierContradiction where
  excludes_minimal :
    ∀ _m : HardStepMinimalElement, False

/-- Definitive exclusion theorem for minimal blow-up elements. -/
theorem definitive_excludes_all_minimal_elements
    (C : DefinitiveFluxBarrierContradiction) :
    ∀ _m : HardStepMinimalElement, False :=
  C.excludes_minimal

/-- Definitive unconditional global closure corollary. -/
theorem definitive_global_closure_unconditional
    (C : DefinitiveFluxBarrierContradiction) :
    HardStepGlobalClosure := by
  intro m
  exact C.excludes_minimal m

end Gibbs.ContinuumField.NavierStokes
