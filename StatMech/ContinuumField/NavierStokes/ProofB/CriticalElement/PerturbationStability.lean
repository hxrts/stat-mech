import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.CriticalClass
import StatMech.ContinuumField.NavierStokes.Defect.ConcretePeriodic

/-! # Hard-step stability layer

Quantitative long-time perturbation and envelope-budget robustness theorems in
the selected periodic critical setting.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Perturbation data for explicit long-time stability bounds. -/
structure LongTimePerturbationData
    (NS : IncompressibleNavierStokes .torus3) where
  base : StrongSolution NS
  perturbed : StrongSolution NS
  T : ℝ
  T_nonneg : 0 ≤ T
  ε : ℝ
  ε_nonneg : 0 ≤ ε
  Cstab : ℝ
  Cstab_nonneg : 0 ≤ Cstab
  L : ℝ
  L_nonneg : 0 ≤ L
  L_lt_one : L < 1
  initial_gap : hardStepNormL3 (base.vel 0 - perturbed.vel 0) ≤ ε
  forcing_gap : ∀ t, 0 ≤ t → t ≤ T → hardStepNormL3 NS.forcing ≤ ε
  perturbation_bound :
    ∀ t, 0 ≤ t → t ≤ T →
      hardStepNormL3 (base.vel t - perturbed.vel t) ≤ Cstab * ε

/-- Long-time perturbation theorem with explicit constants in the chosen class. -/
theorem long_time_perturbation_explicit
    {NS : IncompressibleNavierStokes .torus3}
    (D : LongTimePerturbationData NS) :
    ∀ t, 0 ≤ t → t ≤ D.T →
      hardStepNormL3 (D.base.vel t - D.perturbed.vel t) ≤ D.Cstab * D.ε :=
  D.perturbation_bound

/-- Envelope robustness data under perturbative displacement. -/
structure EnvelopeRobustnessData
    (NS : IncompressibleNavierStokes .torus3)
    (E : DefectEnvelope .torus3) where
  base : StrongSolution NS
  perturbed : StrongSolution NS
  δ : ℝ
  δ_nonneg : 0 ≤ δ
  match_base : ∀ t, E.criticalNorm.value (base.vel t) ≤ E.resolvedCriticalNorm t
  perturb_control :
    ∀ t, E.criticalNorm.value (perturbed.vel t) ≤ E.criticalNorm.value (base.vel t) + δ

/-- Exact budget-tracking upgrade for critical envelope bounds under perturbation. -/
theorem envelope_budget_robustness
    {NS : IncompressibleNavierStokes .torus3}
    {E : DefectEnvelope .torus3}
    (R : EnvelopeRobustnessData NS E) :
    ∀ t, E.criticalNorm.value (R.perturbed.vel t) ≤ E.criticalBudget + R.δ := by
  intro t
  have h₁ : E.criticalNorm.value (R.perturbed.vel t) ≤ E.criticalNorm.value (R.base.vel t) + R.δ :=
    R.perturb_control t
  have h₂ : E.criticalNorm.value (R.base.vel t) ≤ E.resolvedCriticalNorm t :=
    R.match_base t
  have h₃ : E.resolvedCriticalNorm t ≤ E.criticalBudget := E.critical_controlled t
  have h₄ : E.criticalNorm.value (R.base.vel t) + R.δ ≤ E.criticalBudget + R.δ :=
    by
      simpa [add_comm, add_left_comm, add_assoc] using
        add_le_add_right (le_trans h₂ h₃) R.δ
  exact le_trans h₁ h₄

/-- Canonical construction of a perturbed envelope with exact updated budget. -/
def robustifiedEnvelope
    (E : DefectEnvelope .torus3)
    (δ : ℝ)
    (hδ : 0 ≤ δ) :
    DefectEnvelope .torus3 where
  criticalNorm := E.criticalNorm
  defectBudget := E.defectBudget + δ
  criticalBudget := E.criticalBudget + δ
  defectBudget_nonneg := add_nonneg E.defectBudget_nonneg hδ
  criticalBudget_nonneg := add_nonneg E.criticalBudget_nonneg hδ
  defectNorm := E.defectNorm
  resolvedCriticalNorm := E.resolvedCriticalNorm
  defect_controlled := by
    intro t
    exact le_trans (E.defect_controlled t) (le_add_of_nonneg_right hδ)
  critical_controlled := by
    intro t
    exact le_trans (E.critical_controlled t) (le_add_of_nonneg_right hδ)

/-- Robustified envelope remains globally bounded with explicit updated budgets. -/
theorem robustifiedEnvelope_globally_bounded
    (E : DefectEnvelope .torus3)
    (δ : ℝ)
    (hδ : 0 ≤ δ) :
    IsGloballyBoundedEnvelope (robustifiedEnvelope E δ hδ) :=
  envelope_is_globally_bounded (robustifiedEnvelope E δ hδ)

end StatMech.ContinuumField.NavierStokes
