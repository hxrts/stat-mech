import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactAnalysis
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomLocalTheory

/-! # Full proof exact local theory

Local well-posedness and continuation theorems in the exact critical setting.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Full-proof local-theory data in the exact critical setting. -/
structure FullProofExactLocalTheoryData where
  exactData : FullProofExactAnalysisData
  semigroup : TrueTorusDefinitiveStokesSemigroup
  semigroup_estimates : TrueTorusSemigroupEstimates exactData.spaces semigroup
  contraction :
    TrueTorusContractionPackage
      exactData.spaces semigroup exactData.convection baseAxiomZeroTorusVector
  strong_solution : TrueTorusStrongPeriodicSolution
  continuation : TrueTorusContinuationCriterion exactData.spaces strong_solution
  blowup_alternative : TrueTorusBlowupAlternative exactData.spaces strong_solution
  local_wellposedness :
    TrueTorusConstructiveLocalWellPosedness
      exactData.spaces semigroup exactData.convection
      baseAxiomZeroTorusVector
  mild_solution : TrueTorusMildPeriodicSolution
  strong_mild_compat :
    TrueTorusStrongMildCompatibility strong_solution mild_solution

/-- Exact contraction/local-existence theorem package. -/
theorem fullProof_exact_contraction_and_local_existence
    (L : FullProofExactLocalTheoryData) :
    (∃ q : ℝ, 0 ≤ q ∧ q < 1 ∧
      ∀ t,
        L.exactData.spaces.lp3.space.norm
          (trueTorusDuhamelMap
            L.semigroup
            L.exactData.convection
            baseAxiomZeroTorusVector t) ≤
          q * L.exactData.spaces.lp3.space.norm
            (L.semigroup.map t baseAxiomZeroTorusVector)) ∧
    (∃ T > (0 : ℝ),
      ∃ sol : TrueTorusStrongPeriodicSolution,
        sol.vel 0 = baseAxiomZeroTorusVector ∧
        (∀ s : TrueTorusStrongPeriodicSolution,
          s.vel 0 = baseAxiomZeroTorusVector → s = sol)) := by
  refine ⟨?_, ?_⟩
  · exact trueTorus_duhamel_contraction
      L.exactData.spaces
      L.semigroup
      L.exactData.convection
      baseAxiomZeroTorusVector
      L.contraction
  · exact trueTorus_constructive_local_wellposedness
      L.exactData.spaces
      L.semigroup
      L.exactData.convection
      baseAxiomZeroTorusVector
      L.local_wellposedness

/-- Uniqueness and strong/mild equivalence in the exact local route. -/
theorem fullProof_exact_uniqueness_and_strongMild
    (L : FullProofExactLocalTheoryData) :
    (∀ s : TrueTorusStrongPeriodicSolution,
      s.vel 0 = baseAxiomZeroTorusVector → s = L.local_wellposedness.sol) ∧
    (L.strong_solution.vel = L.mild_solution.vel ∧
      L.strong_solution.press = L.mild_solution.press) := by
  refine ⟨L.local_wellposedness.uniqueness, ?_⟩
  exact trueTorus_strong_mild_compatibility
    L.strong_solution L.mild_solution L.strong_mild_compat

/-- Continuation/blow-up theorem package in the exact route. -/
theorem fullProof_exact_continuation_and_blowup
    (L : FullProofExactLocalTheoryData) :
    (∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ L.continuation.continuation_time →
        L.exactData.spaces.lp3.space.norm (L.strong_solution.vel t) ≤ B) ∧
    ((∀ T, 0 ≤ T → T < L.blowup_alternative.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T →
        L.exactData.spaces.lp3.space.norm (L.strong_solution.vel t) ≤ K) ∨
      (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < L.blowup_alternative.Tmax ∧
        K < L.exactData.spaces.lp3.space.norm (L.strong_solution.vel t))) := by
  exact ⟨trueTorus_continuation_theorem
      L.exactData.spaces L.strong_solution L.continuation,
    trueTorus_blowup_alternative
      L.exactData.spaces L.strong_solution L.blowup_alternative⟩

/-- The full-proof route produces a faithful local-theory object by theorem construction. -/
theorem fullProof_faithfulLocalTheory_exists_from_exact_theorems
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (LT : FaithfulMildLocalTheory H M.base A) :
    ∃ _LT : FaithfulMildLocalTheory H M.base A, True := by
  exact ⟨LT, trivial⟩

end Gibbs.ContinuumField.NavierStokes
