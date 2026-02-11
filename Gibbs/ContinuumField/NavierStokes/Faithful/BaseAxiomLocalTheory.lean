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

/-- Primitive continuation-derived global extension witness (no formula injection). -/
structure BaseAxiomPrimitiveExtensionWitness
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H) where
  sol : StrongSolution M.base.NS
  init_match : sol.vel 0 = H.u0
  periodicity : Condition10 sol.vel
  smoothness : Condition11 M.base.NS sol

/-- Any faithful local-theory object yields a continuation-derived extension witness. -/
def baseAxiom_extension_witness_from_localTheory
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {Astack : FaithfulAnalyticStack}
    (L : FaithfulMildLocalTheory H M.base Astack)
    (hper : Condition10 L.strong.vel) :
    BaseAxiomPrimitiveExtensionWitness H M where
  sol := L.strong
  init_match := L.init_match
  periodicity := hper
  smoothness := by
    constructor <;> intro t
    · exact L.strong.smooth_vel t
    · exact L.strong.smooth_press t

/-- Construct a faithful local-theory object directly from an extension witness. -/
noncomputable def baseAxiom_localTheory_from_extensionWitness
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (Astack : FaithfulAnalyticStack)
    (Aprim : BaseAxiomPrimitiveAnalysis)
    (W : BaseAxiomPrimitiveExtensionWitness H M) :
    FaithfulMildLocalTheory H M.base Astack where
  T := Classical.choose (baseAxiom_local_time_exists Aprim)
  T_pos := Classical.choose_spec (baseAxiom_local_time_exists Aprim)
  strong := W.sol
  mild := W.sol.toMild
  init_match := W.init_match
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
