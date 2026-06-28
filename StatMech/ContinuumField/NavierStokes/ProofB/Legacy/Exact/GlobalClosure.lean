import StatMech.ContinuumField.NavierStokes.ProofB.Legacy.Exact.Rigidity
import StatMech.ContinuumField.NavierStokes.ProofB.Legacy.Primitive.GlobalClosure

/-! # Full proof exact global regularity route

Global control, continuation, and smoothness persistence in the exact route.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-! ## Global control -/

/-- No-minimal exclusion implies global control in the exact route. -/
theorem fullProof_noMinimal_implies_globalControl
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m)) :
    HardStepGlobalClosure := by
  exact baseAxiom_unconditional_global_control trajectoryOf flux_hypotheses

/-! ## Continuation and extension -/

/-- Long-time continuation/global extension in the exact route. -/
theorem fullProof_longTime_continuation_globalExtension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m))
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_continuation
    trajectoryOf flux_hypotheses L

/-! ## Smoothness persistence -/

/-- Smoothness persistence in the exact route. -/
theorem fullProof_smoothness_persistence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m))
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  rcases fullProof_longTime_continuation_globalExtension
      trajectoryOf flux_hypotheses L with
      ⟨sol, _hinit, _hper, hsmooth⟩
  exact ⟨sol, hsmooth.1, hsmooth.2⟩

/-! ## Faithful hard-global closure -/

/-- Constructive faithful hard-global closure in the exact route. -/
theorem fullProof_exact_faithfulHardGlobalClosure
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m))
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ _HGd : FaithfulHardGlobalData H M.base A L, True := by
  rcases fullProof_longTime_continuation_globalExtension
      trajectoryOf flux_hypotheses L with ⟨sol, hinit, hper, hsmooth⟩
  exact ⟨L, ⟨sol, hinit, hper, hsmooth⟩, trivial⟩

/-! ## Policy markers -/

/-- Policy marker for the exact global route. -/
def FullProofExactGlobalRoutePolicy : Prop :=
  ∀ trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3,
    (∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m)) →
      HardStepGlobalClosure

/-- Exact global route policy is active. -/
theorem fullProof_exactGlobalRoute_policy :
    FullProofExactGlobalRoutePolicy := by
  intro trajectoryOf flux_hypotheses
  exact fullProof_noMinimal_implies_globalControl trajectoryOf flux_hypotheses

end StatMech.ContinuumField.NavierStokes
