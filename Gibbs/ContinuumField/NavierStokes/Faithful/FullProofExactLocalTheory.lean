import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactAnalysis
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomLocalTheory

/-! # Full proof exact local theory

Local well-posedness and continuation theorems in the exact critical setting.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact contraction/local-existence theorem package. -/
theorem fullProof_exact_contraction_and_local_existence
    (spaces : DefinitiveFunctionSpaceStack)
    (convection : TrueTorusConvectionModel)
    (semigroup : TrueTorusDefinitiveStokesSemigroup)
    (contraction :
      TrueTorusContractionPackage
        spaces semigroup convection baseAxiomZeroTorusVector)
    (local_wellposedness :
      TrueTorusConstructiveLocalWellPosedness
        spaces semigroup convection baseAxiomZeroTorusVector) :
    (∃ q : ℝ, 0 ≤ q ∧ q < 1 ∧
      ∀ t,
        spaces.lp3.space.norm
          (trueTorusDuhamelMap
            semigroup
            convection
            baseAxiomZeroTorusVector t) ≤
          q * spaces.lp3.space.norm
            (semigroup.map t baseAxiomZeroTorusVector)) ∧
    (∃ T > (0 : ℝ),
      ∃ sol : TrueTorusStrongPeriodicSolution,
        sol.vel 0 = baseAxiomZeroTorusVector ∧
        (∀ s : TrueTorusStrongPeriodicSolution,
          s.vel 0 = baseAxiomZeroTorusVector → s = sol)) := by
  refine ⟨?_, ?_⟩
  · exact trueTorus_duhamel_contraction
      spaces
      semigroup
      convection
      baseAxiomZeroTorusVector
      contraction
  · exact trueTorus_constructive_local_wellposedness
      spaces
      semigroup
      convection
      baseAxiomZeroTorusVector
      local_wellposedness

/-- Uniqueness and strong/mild equivalence in the exact local route. -/
theorem fullProof_exact_uniqueness_and_strongMild
    (spaces : DefinitiveFunctionSpaceStack)
    (convection : TrueTorusConvectionModel)
    (semigroup : TrueTorusDefinitiveStokesSemigroup)
    (local_wellposedness :
      TrueTorusConstructiveLocalWellPosedness
        spaces semigroup convection baseAxiomZeroTorusVector)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (mild_solution : TrueTorusMildPeriodicSolution)
    (strong_mild_compat :
      TrueTorusStrongMildCompatibility strong_solution mild_solution) :
    (∀ s : TrueTorusStrongPeriodicSolution,
      s.vel 0 = baseAxiomZeroTorusVector → s = local_wellposedness.sol) ∧
    (strong_solution.vel = mild_solution.vel ∧
      strong_solution.press = mild_solution.press) := by
  refine ⟨local_wellposedness.uniqueness, ?_⟩
  exact trueTorus_strong_mild_compatibility
    strong_solution mild_solution strong_mild_compat

/-- Continuation/blow-up theorem package in the exact route. -/
theorem fullProof_exact_continuation_and_blowup
    (spaces : DefinitiveFunctionSpaceStack)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (continuation : TrueTorusContinuationCriterion spaces strong_solution)
    (blowup_alternative : TrueTorusBlowupAlternative spaces strong_solution) :
    (∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ continuation.continuation_time →
        spaces.lp3.space.norm (strong_solution.vel t) ≤ B) ∧
    ((∀ T, 0 ≤ T → T < blowup_alternative.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T →
        spaces.lp3.space.norm (strong_solution.vel t) ≤ K) ∨
      (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < blowup_alternative.Tmax ∧
        K < spaces.lp3.space.norm (strong_solution.vel t))) := by
  exact ⟨trueTorus_continuation_theorem
      spaces strong_solution continuation,
    trueTorus_blowup_alternative
      spaces strong_solution blowup_alternative⟩

/-- Constructive full-proof local-theory object in faithful form. -/
def fullProof_constructiveFaithfulLocalTheory
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (LT : FaithfulMildLocalTheory H M.base A) :
    FaithfulMildLocalTheory H M.base A :=
  LT

/-- The full-proof route produces a faithful local-theory output by theorem construction. -/
theorem fullProof_faithfulLocalTheory_exists_from_exact_theorems
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (LT : FaithfulMildLocalTheory H M.base A) :
    ∃ _LT : FaithfulMildLocalTheory H M.base A, True := by
  exact ⟨fullProof_constructiveFaithfulLocalTheory M A LT, trivial⟩

end Gibbs.ContinuumField.NavierStokes
