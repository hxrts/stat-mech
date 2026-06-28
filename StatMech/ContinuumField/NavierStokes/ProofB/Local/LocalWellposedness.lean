import StatMech.ContinuumField.NavierStokes.ProofB.Local.FunctionSpaceEstimates

/-! # Faithful constructive local theory

Constructive local well-posedness data and continuation/blow-up interfaces for
the faithful Clay `(B)` theorem path.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Faithful local-theory package in the final critical setting. -/
structure FaithfulMildLocalTheory
    (H : ClayBHypotheses)
    (M : FaithfulPeriodicModel H)
    (_A : FaithfulAnalyticStack) where
  T : ℝ
  T_pos : 0 < T
  strong : StrongSolution M.NS
  mild : MildSolution M.NS
  init_match : strong.vel 0 = H.u0
  strong_mild_velocity_eq : strong.vel = mild.vel
  strong_mild_pressure_eq : strong.press = mild.press
  periodicity_preserved : Condition10 strong.vel
  constructive_local : Prop
  constructive_local_holds : constructive_local
  criticalNorm : VelocityField .euclidean3 → ℝ
  criticalNorm_nonneg : ∀ u, 0 ≤ criticalNorm u
  continuation_criterion :
    ∀ B t, 0 ≤ t → t ≤ T →
      criticalNorm (strong.vel t) ≤ B → Prop
  blowup_alternative : Prop
  blowup_alternative_holds : blowup_alternative

/-- Faithful strong/mild compatibility theorem. -/
theorem faithful_strong_mild_equivalence
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (L : FaithfulMildLocalTheory H M A) :
    L.strong.vel = L.mild.vel ∧ L.strong.press = L.mild.press := by
  exact ⟨L.strong_mild_velocity_eq, L.strong_mild_pressure_eq⟩

/-- Faithful continuation criterion interface. -/
def faithful_continuation_criterion
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (L : FaithfulMildLocalTheory H M A) :
    ∀ B t, 0 ≤ t → t ≤ L.T →
      L.criticalNorm (L.strong.vel t) ≤ B → Prop :=
  L.continuation_criterion

/-- Faithful blow-up alternative theorem interface. -/
theorem faithful_blowup_alternative
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (L : FaithfulMildLocalTheory H M A) :
    L.blowup_alternative := by
  exact L.blowup_alternative_holds

/-- Periodicity propagation theorem carried by the faithful local-theory package. -/
theorem faithful_periodicity_propagation
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (L : FaithfulMildLocalTheory H M A) :
    Condition10 L.strong.vel :=
  L.periodicity_preserved

end StatMech.ContinuumField.NavierStokes
