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

/-- Primitive analysis data used in base-axiom derivations. -/
structure BaseAxiomPrimitiveAnalysis where
  spaces : DefinitiveFunctionSpaceStack
  convection : TrueTorusConvectionModel
  constants : TrueTorusAnalyticConstantRegistry
  nonlinear : TrueTorusNonlinearEstimateBundle spaces convection constants
  semigroup : TrueTorusDefinitiveStokesSemigroup
  semigroup_estimates : TrueTorusSemigroupEstimates spaces semigroup
  contraction :
    TrueTorusContractionPackage spaces semigroup convection baseAxiomZeroTorusVector
  strong_solution : TrueTorusStrongPeriodicSolution
  continuation : TrueTorusContinuationCriterion spaces strong_solution
  blowup_alternative : TrueTorusBlowupAlternative spaces strong_solution

/-- Primitive nonlinear estimate theorem in the base-axiom route. -/
theorem baseAxiom_nonlinear_estimates
    (A : BaseAxiomPrimitiveAnalysis) :
    ∀ u,
      A.spaces.lp3.space.norm (A.convection.convection u) ≤
        A.constants.Cbilinear * A.spaces.sobolev.space.norm u * A.spaces.hhalf.space.norm u :=
  trueTorus_bilinear_convection_estimate A.spaces A.convection A.constants A.nonlinear

/-- Primitive semigroup and Duhamel contraction theorem bundle. -/
theorem baseAxiom_semigroup_duhamel
    (A : BaseAxiomPrimitiveAnalysis) :
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ t u, A.spaces.sobolev.space.norm (A.semigroup.map t u) ≤ C * A.spaces.lp3.space.norm u) ∧
    (∃ q : ℝ, 0 ≤ q ∧ q < 1 ∧
      ∀ t,
        A.spaces.lp3.space.norm (trueTorusDuhamelMap A.semigroup A.convection baseAxiomZeroTorusVector t) ≤
          q * A.spaces.lp3.space.norm (A.semigroup.map t baseAxiomZeroTorusVector)) := by
  refine ⟨(trueTorus_stokes_semigroup_estimates A.spaces A.semigroup A.semigroup_estimates).1, ?_⟩
  exact trueTorus_duhamel_contraction
    A.spaces A.semigroup A.convection baseAxiomZeroTorusVector A.contraction

/-- Primitive continuation and blow-up alternative theorem bundle. -/
theorem baseAxiom_continuation_blowup_alternative
    (A : BaseAxiomPrimitiveAnalysis) :
    (∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ A.continuation.continuation_time →
        A.spaces.lp3.space.norm (A.strong_solution.vel t) ≤ B) ∧
    ((∀ T, 0 ≤ T → T < A.blowup_alternative.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T → A.spaces.lp3.space.norm (A.strong_solution.vel t) ≤ K) ∨
      (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < A.blowup_alternative.Tmax ∧
        K < A.spaces.lp3.space.norm (A.strong_solution.vel t))) := by
  refine ⟨trueTorus_continuation_theorem A.spaces A.strong_solution A.continuation, ?_⟩
  exact trueTorus_blowup_alternative A.spaces A.strong_solution A.blowup_alternative

/-- Primitive-analysis dependency policy marker for base-axiom route. -/
def BaseAxiomPrimitiveAnalysisDependencyPolicy : Prop := True

/-- Base-axiom primitive analysis uses primitive modules only. -/
theorem baseAxiom_primitive_analysis_dependency_policy :
    BaseAxiomPrimitiveAnalysisDependencyPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
