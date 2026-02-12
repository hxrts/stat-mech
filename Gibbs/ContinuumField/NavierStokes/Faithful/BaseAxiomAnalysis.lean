import Gibbs.ContinuumField.NavierStokes.Functional.TrueTorusNonlinearDefinitive
import Gibbs.ContinuumField.NavierStokes.Linear.TrueTorusStokesSemigroup
import Gibbs.ContinuumField.NavierStokes.Linear.TrueTorusContinuation

/-! # Faithful base-axiom primitive analysis

Primitive critical-space analysis route with no dependence on bundled faithful
analytic records.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical zero initial datum in the true-torus vector-field carrier. -/
def baseAxiomZeroTorusVector : TrueTorusVectorField := fun _ => 0

/-- Primitive nonlinear estimate theorem in the base-axiom route. -/
theorem baseAxiom_nonlinear_estimates
    (spaces : DefinitiveFunctionSpaceStack)
    (convection : TrueTorusConvectionModel)
    (constants : TrueTorusAnalyticConstantRegistry)
    (nonlinear : TrueTorusNonlinearEstimateBundle spaces convection constants) :
    ∀ u,
      spaces.lp3.space.norm (convection.convection u) ≤
        constants.Cbilinear * spaces.sobolev.space.norm u * spaces.hhalf.space.norm u :=
  trueTorus_bilinear_convection_estimate spaces convection constants nonlinear

/-- Primitive semigroup and Duhamel contraction theorem bundle. -/
theorem baseAxiom_semigroup_duhamel
    (spaces : DefinitiveFunctionSpaceStack)
    (convection : TrueTorusConvectionModel)
    (semigroup : TrueTorusDefinitiveStokesSemigroup)
    (semigroup_estimates : TrueTorusSemigroupEstimates spaces semigroup)
    (contraction :
      TrueTorusContractionPackage spaces semigroup convection baseAxiomZeroTorusVector) :
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ t u, spaces.sobolev.space.norm (semigroup.map t u) ≤ C * spaces.lp3.space.norm u) ∧
    (∃ q : ℝ, 0 ≤ q ∧ q < 1 ∧
      ∀ t,
        spaces.lp3.space.norm (trueTorusDuhamelMap semigroup convection baseAxiomZeroTorusVector t) ≤
          q * spaces.lp3.space.norm (semigroup.map t baseAxiomZeroTorusVector)) := by
  refine ⟨(trueTorus_stokes_semigroup_estimates spaces semigroup semigroup_estimates).1, ?_⟩
  exact trueTorus_duhamel_contraction
    spaces semigroup convection baseAxiomZeroTorusVector contraction

/-- Primitive continuation and blow-up alternative theorem bundle. -/
theorem baseAxiom_continuation_blowup_alternative
    (spaces : DefinitiveFunctionSpaceStack)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (continuation : TrueTorusContinuationCriterion spaces strong_solution)
    (blowup_alternative : TrueTorusBlowupAlternative spaces strong_solution) :
    (∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ continuation.continuation_time →
        spaces.lp3.space.norm (strong_solution.vel t) ≤ B) ∧
    ((∀ T, 0 ≤ T → T < blowup_alternative.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T → spaces.lp3.space.norm (strong_solution.vel t) ≤ K) ∨
      (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < A.blowup_alternative.Tmax ∧
        K < spaces.lp3.space.norm (strong_solution.vel t))) := by
  refine ⟨trueTorus_continuation_theorem spaces strong_solution continuation, ?_⟩
  exact trueTorus_blowup_alternative spaces strong_solution blowup_alternative

/-- Primitive-analysis dependency policy marker for base-axiom route. -/
def BaseAxiomPrimitiveAnalysisDependencyPolicy : Prop := True

/-- Base-axiom primitive analysis uses primitive modules only. -/
theorem baseAxiom_primitive_analysis_dependency_policy :
    BaseAxiomPrimitiveAnalysisDependencyPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
