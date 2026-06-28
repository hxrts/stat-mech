import StatMech.ContinuumField.NavierStokes.Defect.Envelope

/-! # Defect estimates

Basic estimate lemmas that connect envelopes to continuation-style control.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Absolute-value control by the defect budget. -/
theorem defect_abs_le_budget {D : SpatialDomain3} (E : DefectEnvelope D)
    (habs : ∀ t, |E.defectNorm t| ≤ E.defectNorm t) :
    ∀ t, |E.defectNorm t| ≤ E.defectBudget := by
  intro t
  exact le_trans (habs t) (E.defect_controlled t)

/-- Resolved critical norm is globally controlled by the critical budget. -/
theorem resolved_critical_le_budget {D : SpatialDomain3} (E : DefectEnvelope D) :
    ∀ t, E.resolvedCriticalNorm t ≤ E.criticalBudget :=
  E.critical_controlled

/-- Difference of defect norms is bounded by doubled defect budget. -/
theorem defect_diff_le_double_budget {D : SpatialDomain3} (E : DefectEnvelope D)
    (habs : ∀ t, |E.defectNorm t| ≤ E.defectBudget)
    (t₁ t₂ : ℝ) :
    E.defectNorm t₁ - E.defectNorm t₂ ≤ E.defectBudget + E.defectBudget := by
  have h₁ : E.defectNorm t₁ ≤ E.defectBudget :=
    (abs_le.mp (habs t₁)).2
  have h₂left : -E.defectBudget ≤ E.defectNorm t₂ :=
    (abs_le.mp (habs t₂)).1
  have h₂ : -E.defectNorm t₂ ≤ E.defectBudget := by
    have hneg : -E.defectNorm t₂ ≤ -(-E.defectBudget) := neg_le_neg h₂left
    simpa [neg_neg] using hneg
  have hsum : E.defectNorm t₁ + (-E.defectNorm t₂) ≤ E.defectBudget + E.defectBudget :=
    add_le_add h₁ h₂
  simpa [sub_eq_add_neg] using hsum

/-- Differential-inequality data linking defect growth to resolved critical norms. -/
structure EnvelopeDifferentialControl {D : SpatialDomain3} (E : DefectEnvelope D) where
  /-- Time derivative proxy for the defect envelope. -/
  dDefect : ℝ → ℝ
  /-- Linear growth coefficients. -/
  alpha : ℝ
  beta : ℝ
  /-- Nonnegativity assumptions needed for monotone bounds. -/
  alpha_nonneg : 0 ≤ alpha
  beta_nonneg : 0 ≤ beta
  /-- Differential inequality in terms of resolved critical norms. -/
  differential_ineq : ∀ t, dDefect t ≤ alpha * E.resolvedCriticalNorm t + beta

/-- Global envelope control upgrades the differential inequality to a uniform bound. -/
theorem differential_control_uniform_bound {D : SpatialDomain3}
    (E : DefectEnvelope D)
    (C : EnvelopeDifferentialControl E) :
    ∀ t, C.dDefect t ≤ C.alpha * E.criticalBudget + C.beta := by
  intro t
  have h₁ : C.dDefect t ≤ C.alpha * E.resolvedCriticalNorm t + C.beta :=
    C.differential_ineq t
  have h₂ : C.alpha * E.resolvedCriticalNorm t ≤ C.alpha * E.criticalBudget := by
    exact mul_le_mul_of_nonneg_left (E.critical_controlled t) C.alpha_nonneg
  have h₃ : C.alpha * E.resolvedCriticalNorm t + C.beta ≤ C.alpha * E.criticalBudget + C.beta := by
    simpa [add_comm, add_left_comm, add_assoc] using add_le_add_right h₂ C.beta
  exact le_trans h₁ h₃

end StatMech.ContinuumField.NavierStokes
