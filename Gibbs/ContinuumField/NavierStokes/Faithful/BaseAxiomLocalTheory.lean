import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomAnalysis
import Gibbs.ContinuumField.NavierStokes.Faithful.LocalTheory
import Gibbs.ContinuumField.NavierStokes.Faithful.PDERealization

/-! # Faithful base-axiom local theory extraction

Primitive local-time control and blow-up alternatives derived directly from the
base-axiom analysis bundle.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Primitive local-time existence theorem from continuation data. -/
theorem baseAxiom_local_time_exists
    {spaces : DefinitiveFunctionSpaceStack}
    {strong_solution : TrueTorusStrongPeriodicSolution}
    (continuation : TrueTorusContinuationCriterion spaces strong_solution) :
    ∃ T : ℝ, 0 < T := by
  exact ⟨continuation.continuation_time, continuation.continuation_time_pos⟩

/-- Primitive local critical-norm bound from continuation theorem. -/
theorem baseAxiom_local_critical_bound
    (spaces : DefinitiveFunctionSpaceStack)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (continuation : TrueTorusContinuationCriterion spaces strong_solution) :
    ∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ continuation.continuation_time →
        spaces.lp3.space.norm (strong_solution.vel t) ≤ B := by
  exact trueTorus_continuation_theorem spaces strong_solution continuation

/-- Primitive blow-up alternative in the chosen critical norm. -/
theorem baseAxiom_local_blowup_alternative
    (spaces : DefinitiveFunctionSpaceStack)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (blowup_alternative : TrueTorusBlowupAlternative spaces strong_solution) :
    (∀ T, 0 ≤ T → T < blowup_alternative.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T → spaces.lp3.space.norm (strong_solution.vel t) ≤ K) ∨
    (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < blowup_alternative.Tmax ∧
      K < spaces.lp3.space.norm (strong_solution.vel t)) := by
  exact trueTorus_blowup_alternative spaces strong_solution blowup_alternative

/-- Base-axiom local-theory dependency policy for primitive continuation outputs. -/
def BaseAxiomLocalTheoryDependencyPolicy : Prop :=
  ∀ (spaces : DefinitiveFunctionSpaceStack)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (continuation : TrueTorusContinuationCriterion spaces strong_solution),
      ∃ B : ℝ,
        0 ≤ B ∧
        ∀ t, 0 ≤ t → t ≤ continuation.continuation_time →
          spaces.lp3.space.norm (strong_solution.vel t) ≤ B

/-- Base-axiom local-theory dependency policy theorem. -/
theorem baseAxiom_localTheory_dependency_policy :
    BaseAxiomLocalTheoryDependencyPolicy := by
  intro spaces strong_solution continuation
  exact baseAxiom_local_critical_bound spaces strong_solution continuation

end Gibbs.ContinuumField.NavierStokes
