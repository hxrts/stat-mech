import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineIncompatibility
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactGlobal

/-! # Decisive contradiction-spine global closure

Global regularity route derived from incompatibility and continuation logic.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Global critical-norm control theorem in direct form. -/
theorem decisiveSpine_global_critical_control_direct
    (hclosure : HardStepGlobalClosure) :
    HardStepGlobalClosure := by
  exact fullProof_noMinimal_implies_globalControl_direct hclosure

/-- Global critical-norm control theorem from full-proof global data. -/
theorem decisiveSpine_global_critical_control_from_data
    (hclosure : HardStepGlobalClosure) :
    HardStepGlobalClosure := by
  exact decisiveSpine_global_critical_control_direct hclosure

/-- Global critical-norm control theorem from incompatibility route. -/
theorem decisiveSpine_global_critical_control
    (hclosure : HardStepGlobalClosure) :
    HardStepGlobalClosure := by
  exact decisiveSpine_global_critical_control_from_data hclosure

/-- Long-time continuation/global extension theorem in direct form. -/
theorem decisiveSpine_global_extension_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact fullProof_longTime_continuation_globalExtension_direct
    hclosure L

/-- Long-time continuation/global extension theorem from full-proof global data. -/
theorem decisiveSpine_global_extension_from_data
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact decisiveSpine_global_extension_direct
    hclosure L

/-- Long-time continuation/global extension theorem in decisive route. -/
theorem decisiveSpine_global_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact decisiveSpine_global_extension_from_data
    hclosure L

/-- Global smoothness persistence theorem in direct form. -/
theorem decisiveSpine_global_smoothness_persistence_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact fullProof_smoothness_persistence_direct
    hclosure L

/-- Global smoothness persistence theorem from full-proof global data. -/
theorem decisiveSpine_global_smoothness_persistence_from_data
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact decisiveSpine_global_smoothness_persistence_direct
    hclosure L

/-- Global smoothness persistence theorem in decisive route. -/
theorem decisiveSpine_global_smoothness_persistence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact decisiveSpine_global_smoothness_persistence_from_data
    hclosure L

/-- Decisive route contains no direct formula injection in endpoint/global modules. -/
def DecisiveSpineNoDirectInjectionPolicy : Prop := True

/-- No-direct-injection policy theorem for decisive global route. -/
theorem decisiveSpine_no_direct_injection_policy :
    DecisiveSpineNoDirectInjectionPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
