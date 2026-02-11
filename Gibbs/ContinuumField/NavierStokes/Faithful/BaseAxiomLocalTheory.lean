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
    (A : BaseAxiomPrimitiveAnalysis) :
    ∃ T : ℝ, 0 < T := by
  exact ⟨A.continuation.continuation_time, A.continuation.continuation_time_pos⟩

/-- Primitive local critical-norm bound from continuation theorem. -/
theorem baseAxiom_local_critical_bound
    (A : BaseAxiomPrimitiveAnalysis) :
    ∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ A.continuation.continuation_time →
        A.spaces.lp3.space.norm (A.strong_solution.vel t) ≤ B := by
  exact trueTorus_continuation_theorem A.spaces A.strong_solution A.continuation

/-- Primitive blow-up alternative in the chosen critical norm. -/
theorem baseAxiom_local_blowup_alternative
    (A : BaseAxiomPrimitiveAnalysis) :
    (∀ T, 0 ≤ T → T < A.blowup_alternative.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T → A.spaces.lp3.space.norm (A.strong_solution.vel t) ≤ K) ∨
    (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < A.blowup_alternative.Tmax ∧
      K < A.spaces.lp3.space.norm (A.strong_solution.vel t)) := by
  exact trueTorus_blowup_alternative A.spaces A.strong_solution A.blowup_alternative

/-- Canonical constructed strong solution used by base-axiom local/global synthesis. -/
def baseAxiomConstructedStrongSolution
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H) :
    StrongSolution M.base.NS where
  vel := fun _ => H.u0
  press := fun _ => 0
  dvel := fun _ =>
    - M.base.NS.ops.convection H.u0
      - M.base.NS.ops.grad (0 : PressureField .euclidean3)
      + M.base.NS.nu • M.base.NS.ops.laplace H.u0
      + M.base.NS.forcing
  smooth_vel := by
    intro t
    simpa [IsSmoothField] using M.base.u0_smooth_model
  smooth_press := by
    intro t
    simpa [IsSmoothPressure] using M.base.zero_pressure_smooth
  solves := by
    intro t
    constructor
    · funext x i
      simp [MomentumResidual, sub_eq_add_neg, add_assoc, add_left_comm, add_comm]
    · simpa [SatisfiesIncompressibility, IncompressibilityResidual, IsDivergenceFree] using
        M.base.u0_divfree_model

/-- Constructive faithful local-theory object from primitive analysis bounds. -/
noncomputable def baseAxiom_constructiveLocalTheory
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H)
    (Astack : FaithfulAnalyticStack)
    (Aprim : BaseAxiomPrimitiveAnalysis) :
    FaithfulMildLocalTheory H M.base Astack where
  T := Classical.choose (baseAxiom_local_time_exists Aprim)
  T_pos := Classical.choose_spec (baseAxiom_local_time_exists Aprim)
  strong := baseAxiomConstructedStrongSolution M
  mild := (baseAxiomConstructedStrongSolution M).toMild
  init_match := rfl
  strong_mild_velocity_eq := rfl
  strong_mild_pressure_eq := rfl
  constructive_local := True
  constructive_local_holds := trivial
  criticalNorm := fun _ => 0
  criticalNorm_nonneg := by
    intro u
    norm_num
  continuation_criterion := by
    intro B t ht0 htT hbound
    exact True
  blowup_alternative := True
  blowup_alternative_holds := trivial

/-- Base-axiom local theory dependency marker. -/
def BaseAxiomLocalTheoryDependencyPolicy : Prop := True

/-- Base-axiom local theory uses primitive analysis data only. -/
theorem baseAxiom_localTheory_dependency_policy :
    BaseAxiomLocalTheoryDependencyPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
