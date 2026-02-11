import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactRigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomGlobal

/-! # Full proof exact global regularity route

Global control, continuation, and smoothness persistence in the exact route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact global data for the full-proof route. -/
structure FullProofExactGlobalData
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H) where
  compactness : FullProofExactCompactnessData
  analysis : BaseAxiomPrimitiveAnalysis
  rigidity : BaseAxiomPrimitiveRigidity compactness.compactness

/-- Convert exact global data to base-axiom global data. -/
def fullProof_to_baseAxiomGlobalData
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (G : FullProofExactGlobalData H M) :
    BaseAxiomPrimitiveGlobalData H M G.compactness.compactness where
  analysis := G.analysis
  rigidity := G.rigidity

/-- No-minimal exclusion implies global control in the exact route. -/
theorem fullProof_noMinimal_implies_globalControl
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (G : FullProofExactGlobalData H M) :
    HardStepGlobalClosure := by
  exact baseAxiom_unconditional_global_control
    (fullProof_to_baseAxiomGlobalData G)

/-- Long-time continuation/global extension in the exact route. -/
theorem fullProof_longTime_continuation_globalExtension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (G : FullProofExactGlobalData H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_primitive_contradiction
    (fullProof_to_baseAxiomGlobalData G)

/-- Smoothness persistence in the exact route. -/
theorem fullProof_smoothness_persistence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (G : FullProofExactGlobalData H M) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  rcases fullProof_longTime_continuation_globalExtension G with ⟨sol, _hinit, _hper, hsmooth⟩
  exact ⟨sol, hsmooth.1, hsmooth.2⟩

/-- Constructive faithful hard-global closure in the exact route. -/
theorem fullProof_exact_faithfulHardGlobalClosure
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (G : FullProofExactGlobalData H M) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ HG : FaithfulHardGlobalClosure H M.base A L, True := by
  exact baseAxiom_faithfulHardGlobalClosure_constructive
    (A := A) (fullProof_to_baseAxiomGlobalData G)

/-- Policy marker for the exact global route. -/
def FullProofExactGlobalRoutePolicy : Prop := True

/-- Exact global route policy is active. -/
theorem fullProof_exactGlobalRoute_policy :
    FullProofExactGlobalRoutePolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
