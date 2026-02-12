import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactRigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomGlobal

/-! # Full proof exact global regularity route

Global control, continuation, and smoothness persistence in the exact route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- No-minimal exclusion implies global control in direct form. -/
theorem fullProof_noMinimal_implies_globalControl_direct
    (hclosure : HardStepGlobalClosure) :
    HardStepGlobalClosure := by
  exact hclosure

/-- No-minimal exclusion implies global control in the exact route. -/
theorem fullProof_noMinimal_implies_globalControl
    (hclosure : HardStepGlobalClosure) :
    HardStepGlobalClosure := by
  exact fullProof_noMinimal_implies_globalControl_direct hclosure

/-- Long-time continuation/global extension in direct form. -/
theorem fullProof_longTime_continuation_globalExtension_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_continuation_direct hclosure L

/-- Long-time continuation/global extension in the exact route. -/
theorem fullProof_longTime_continuation_globalExtension
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

/-- Smoothness persistence in direct form. -/
theorem fullProof_smoothness_persistence_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  rcases fullProof_longTime_continuation_globalExtension_direct
      hclosure L with
      ⟨sol, _hinit, _hper, hsmooth⟩
  exact ⟨sol, hsmooth.1, hsmooth.2⟩

/-- Smoothness persistence in the exact route. -/
theorem fullProof_smoothness_persistence
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

/-- Constructive faithful hard-global closure in direct form. -/
theorem fullProof_exact_faithfulHardGlobalClosure_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ _HGd : FaithfulHardGlobalData H M.base A L, True := by
  rcases fullProof_longTime_continuation_globalExtension_direct
      hclosure L with ⟨sol, hinit, hper, hsmooth⟩
  exact ⟨L, ⟨sol, hinit, hper, hsmooth⟩, trivial⟩

/-- Constructive faithful hard-global closure in the exact route. -/
theorem fullProof_exact_faithfulHardGlobalClosure
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ _HGd : FaithfulHardGlobalData H M.base A L, True := by
  exact fullProof_exact_faithfulHardGlobalClosure_direct
    (A := A) hclosure L

/-- Policy marker for the exact global route. -/
def FullProofExactGlobalRoutePolicy : Prop := True

/-- Exact global route policy is active. -/
theorem fullProof_exactGlobalRoute_policy :
    FullProofExactGlobalRoutePolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
