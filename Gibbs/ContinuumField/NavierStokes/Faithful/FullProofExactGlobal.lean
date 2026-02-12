import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactRigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomGlobal

/-! # Full proof exact global regularity route

Global control, continuation, and smoothness persistence in the exact route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- No-minimal exclusion implies global control in direct form. -/
theorem fullProof_noMinimal_implies_globalControl_direct
    (flux_package : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  exact baseAxiom_unconditional_global_control_direct flux_package

/-- No-minimal exclusion implies global control in the exact route. -/
theorem fullProof_noMinimal_implies_globalControl
    (flux_package : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  exact fullProof_noMinimal_implies_globalControl_direct flux_package

/-- Long-time continuation/global extension in direct form. -/
theorem fullProof_longTime_continuation_globalExtension_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_strong_solution_extension_direct
    flux_package extension_hypotheses

/-- Long-time continuation/global extension in the exact route. -/
theorem fullProof_longTime_continuation_globalExtension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact fullProof_longTime_continuation_globalExtension_direct
    flux_package extension_hypotheses

/-- Smoothness persistence in direct form. -/
theorem fullProof_smoothness_persistence_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  rcases fullProof_longTime_continuation_globalExtension_direct
      flux_package extension_hypotheses with
      ⟨sol, _hinit, _hper, hsmooth⟩
  exact ⟨sol, hsmooth.1, hsmooth.2⟩

/-- Smoothness persistence in the exact route. -/
theorem fullProof_smoothness_persistence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact fullProof_smoothness_persistence_direct
    flux_package extension_hypotheses

/-- Constructive faithful hard-global closure in direct form. -/
theorem fullProof_exact_faithfulHardGlobalClosure_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (analysis_hypotheses : BaseAxiomPrimitiveAnalysis)
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ _HG : FaithfulHardGlobalClosure H M.base A L, True := by
  exact baseAxiom_faithfulHardGlobalClosure_constructive_direct
    (A := A) analysis_hypotheses flux_package extension_hypotheses

/-- Constructive faithful hard-global closure in the exact route. -/
theorem fullProof_exact_faithfulHardGlobalClosure
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (analysis_hypotheses : BaseAxiomPrimitiveAnalysis)
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ _HG : FaithfulHardGlobalClosure H M.base A L, True := by
  exact fullProof_exact_faithfulHardGlobalClosure_direct
    (A := A) analysis_hypotheses flux_package extension_hypotheses

/-- Policy marker for the exact global route. -/
def FullProofExactGlobalRoutePolicy : Prop := True

/-- Exact global route policy is active. -/
theorem fullProof_exactGlobalRoute_policy :
    FullProofExactGlobalRoutePolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
