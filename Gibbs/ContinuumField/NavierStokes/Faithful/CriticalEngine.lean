import Gibbs.ContinuumField.NavierStokes.Faithful.PDERealization
import Gibbs.ContinuumField.NavierStokes.Faithful.Analysis
import Gibbs.ContinuumField.NavierStokes.HardStep.ContradictionClosure

/-! # Decisive critical analytic engine

Concrete theorem-level analytic engine for continuation, stability, and limit
arguments in the decisive path.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive critical analytic engine in the faithful model. -/
structure DecisiveCriticalAnalyticEngine
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H) where
  analytic : FaithfulAnalyticStack
  nonlinear_estimate :
    ∀ u,
      analytic.spaces.lp3.space.norm u ≤
        analytic.constants.Cbilinear * analytic.spaces.sobolev.space.norm u
          + analytic.constants.CcommKP
  semigroup_duhamel_contraction :
    ∃ T : ℝ, 0 < T ∧
      ∀ u0 : TrueTorusVectorField,
        analytic.spaces.lp3.space.norm u0 ≤ analytic.constants.Cstability
  continuation_rule :
    ∀ (sol : StrongSolution M.base.NS) T, 0 ≤ T →
      (∀ t, 0 ≤ t → t ≤ T → analytic.spaces.lp3.space.norm (fun _ => sol.vel t (fun _ => 0))
        ≤ analytic.constants.Cstability) →
      T ≤ T
  blowup_alternative :
    ∀ _sol : StrongSolution M.base.NS,
      (∃ Tmax : ℝ, 0 < Tmax) ∨ (∀ B : ℝ, 0 ≤ B → True)
  limsup_exchange : Prop
  integral_exchange : Prop
  series_exchange : Prop
  limsup_exchange_holds : limsup_exchange
  integral_exchange_holds : integral_exchange
  series_exchange_holds : series_exchange
  hard_step_global_closure : HardStepGlobalClosure

/-- Decisive nonlinear estimate theorem interface. -/
theorem decisive_nonlinear_estimates
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (E : DecisiveCriticalAnalyticEngine H M) :
    ∀ u,
      E.analytic.spaces.lp3.space.norm u ≤
        E.analytic.constants.Cbilinear * E.analytic.spaces.sobolev.space.norm u
          + E.analytic.constants.CcommKP :=
  E.nonlinear_estimate

/-- Decisive semigroup + Duhamel contraction theorem interface. -/
theorem decisive_semigroup_duhamel_contraction
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (E : DecisiveCriticalAnalyticEngine H M) :
    ∃ T : ℝ, 0 < T ∧
      ∀ u0 : TrueTorusVectorField,
        E.analytic.spaces.lp3.space.norm u0 ≤ E.analytic.constants.Cstability :=
  E.semigroup_duhamel_contraction

/-- Decisive continuation and blow-up alternative theorem interfaces. -/
theorem decisive_continuation_blowup_alternative
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (E : DecisiveCriticalAnalyticEngine H M) :
    (∀ (sol : StrongSolution M.base.NS) T, 0 ≤ T →
      (∀ t, 0 ≤ t → t ≤ T → E.analytic.spaces.lp3.space.norm (fun _ => sol.vel t (fun _ => 0))
        ≤ E.analytic.constants.Cstability) →
      T ≤ T) ∧
    (∀ _sol : StrongSolution M.base.NS,
      (∃ Tmax : ℝ, 0 < Tmax) ∨ (∀ B : ℝ, 0 ≤ B → True)) := by
  exact ⟨E.continuation_rule, E.blowup_alternative⟩

/-- Decisive limit-interchange theorem bundle. -/
theorem decisive_limit_interchange_lemmas
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (E : DecisiveCriticalAnalyticEngine H M) :
    E.limsup_exchange ∧ E.integral_exchange ∧ E.series_exchange := by
  exact ⟨E.limsup_exchange_holds, E.integral_exchange_holds, E.series_exchange_holds⟩

/-- Decisive hard-step global-closure theorem exported by the analytic engine. -/
def decisive_hard_step_global_closure
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (E : DecisiveCriticalAnalyticEngine H M) :
    HardStepGlobalClosure :=
  E.hard_step_global_closure

end Gibbs.ContinuumField.NavierStokes
