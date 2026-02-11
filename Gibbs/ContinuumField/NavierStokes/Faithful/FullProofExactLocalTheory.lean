import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactAnalysis
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomLocalTheory

/-! # Full proof exact local theory

Local well-posedness and continuation theorems in the exact critical setting.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Full-proof local-theory data in the exact critical setting. -/
structure FullProofExactLocalTheoryData where
  route : FullProofExactAnalysisRoute
  local_wellposedness :
    TrueTorusConstructiveLocalWellPosedness
      route.exactData.spaces route.semigroup route.exactData.convection
      baseAxiomZeroTorusVector
  mild_solution : TrueTorusMildPeriodicSolution
  strong_mild_compat :
    TrueTorusStrongMildCompatibility route.strong_solution mild_solution

/-- Exact contraction/local-existence theorem package. -/
theorem fullProof_exact_contraction_and_local_existence
    (L : FullProofExactLocalTheoryData) :
    (∃ q : ℝ, 0 ≤ q ∧ q < 1 ∧
      ∀ t,
        L.route.exactData.spaces.lp3.space.norm
          (trueTorusDuhamelMap
            L.route.semigroup
            L.route.exactData.convection
            baseAxiomZeroTorusVector t) ≤
          q * L.route.exactData.spaces.lp3.space.norm
            (L.route.semigroup.map t baseAxiomZeroTorusVector)) ∧
    (∃ T > (0 : ℝ),
      ∃ sol : TrueTorusStrongPeriodicSolution,
        sol.vel 0 = baseAxiomZeroTorusVector ∧
        (∀ s : TrueTorusStrongPeriodicSolution,
          s.vel 0 = baseAxiomZeroTorusVector → s = sol)) := by
  refine ⟨?_, ?_⟩
  · exact trueTorus_duhamel_contraction
      L.route.exactData.spaces
      L.route.semigroup
      L.route.exactData.convection
      baseAxiomZeroTorusVector
      L.route.contraction
  · exact trueTorus_constructive_local_wellposedness
      L.route.exactData.spaces
      L.route.semigroup
      L.route.exactData.convection
      baseAxiomZeroTorusVector
      L.local_wellposedness

/-- Uniqueness and strong/mild equivalence in the exact local route. -/
theorem fullProof_exact_uniqueness_and_strongMild
    (L : FullProofExactLocalTheoryData) :
    (∀ s : TrueTorusStrongPeriodicSolution,
      s.vel 0 = baseAxiomZeroTorusVector → s = L.local_wellposedness.sol) ∧
    (L.route.strong_solution.vel = L.mild_solution.vel ∧
      L.route.strong_solution.press = L.mild_solution.press) := by
  refine ⟨L.local_wellposedness.uniqueness, ?_⟩
  exact trueTorus_strong_mild_compatibility
    L.route.strong_solution L.mild_solution L.strong_mild_compat

/-- Continuation/blow-up theorem package in the exact route. -/
theorem fullProof_exact_continuation_and_blowup
    (L : FullProofExactLocalTheoryData) :
    (∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ L.route.continuation.continuation_time →
        L.route.exactData.spaces.lp3.space.norm (L.route.strong_solution.vel t) ≤ B) ∧
    ((∀ T, 0 ≤ T → T < L.route.blowup_alternative.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T →
        L.route.exactData.spaces.lp3.space.norm (L.route.strong_solution.vel t) ≤ K) ∨
      (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < L.route.blowup_alternative.Tmax ∧
        K < L.route.exactData.spaces.lp3.space.norm (L.route.strong_solution.vel t))) := by
  exact ⟨trueTorus_continuation_theorem
      L.route.exactData.spaces L.route.strong_solution L.route.continuation,
    trueTorus_blowup_alternative
      L.route.exactData.spaces L.route.strong_solution L.route.blowup_alternative⟩

/-- Constructive faithful local-theory object from the exact theorem route. -/
noncomputable def fullProof_constructiveFaithfulLocalTheory
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (L : FullProofExactLocalTheoryData)
    (W : BaseAxiomPrimitiveExtensionWitness H M) :
    FaithfulMildLocalTheory H M.base A :=
  baseAxiom_localTheory_from_extensionWitness
    A (fullProof_to_baseAxiomPrimitiveAnalysis L.route) W

/-- The full-proof route produces a faithful local-theory object by theorem construction. -/
theorem fullProof_faithfulLocalTheory_exists_from_exact_theorems
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (L : FullProofExactLocalTheoryData)
    (W : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ _LT : FaithfulMildLocalTheory H M.base A, True := by
  exact ⟨fullProof_constructiveFaithfulLocalTheory M A L W, trivial⟩

end Gibbs.ContinuumField.NavierStokes
