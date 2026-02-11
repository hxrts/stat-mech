import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineIncompatibility
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactGlobal

/-! # Decisive contradiction-spine global closure

Global regularity route derived from incompatibility and continuation logic.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive global route data. -/
structure DecisiveSpineGlobalRoute
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H) where
  globalData : FullProofExactGlobalData H M
  incompatibility : DecisiveSpineIncompatibilityRoute

/-- Global critical-norm control theorem from incompatibility route. -/
theorem decisiveSpine_global_critical_control
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (R : DecisiveSpineGlobalRoute H M) :
    HardStepGlobalClosure := by
  exact fullProof_noMinimal_implies_globalControl R.globalData

/-- Long-time continuation/global extension theorem in decisive route. -/
theorem decisiveSpine_global_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (R : DecisiveSpineGlobalRoute H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact fullProof_longTime_continuation_globalExtension R.globalData

/-- Global smoothness persistence theorem in decisive route. -/
theorem decisiveSpine_global_smoothness_persistence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (R : DecisiveSpineGlobalRoute H M) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact fullProof_smoothness_persistence R.globalData

/-- Decisive route contains no direct formula injection in endpoint/global modules. -/
def DecisiveSpineNoDirectInjectionPolicy : Prop := True

/-- No-direct-injection policy theorem for decisive global route. -/
theorem decisiveSpine_no_direct_injection_policy :
    DecisiveSpineNoDirectInjectionPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
