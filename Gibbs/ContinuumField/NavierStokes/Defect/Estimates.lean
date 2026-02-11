import Gibbs.ContinuumField.NavierStokes.Defect.Envelope

/-!
# Defect estimates

Basic estimate lemmas that connect envelopes to continuation-style control.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Absolute-value control by the envelope budget, given a pointwise estimate. -/
theorem defect_abs_le_budget {D : SpatialDomain3} (E : DefectEnvelope D)
    (habs : ∀ t, |E.defectNorm t| ≤ E.defectNorm t) :
    ∀ t, |E.defectNorm t| ≤ E.budget := by
  intro t
  exact le_trans (habs t) (E.controlled t)

/-- Difference of two defect norms is bounded by budget sum under envelope control. -/
theorem defect_diff_le_double_budget {D : SpatialDomain3} (E : DefectEnvelope D)
    (habs : ∀ t, |E.defectNorm t| ≤ E.budget)
    (t₁ t₂ : ℝ) :
    E.defectNorm t₁ - E.defectNorm t₂ ≤ E.budget + E.budget := by
  have h₁ : E.defectNorm t₁ ≤ E.budget := by
    exact (abs_le.mp (habs t₁)).2
  have h₂ : -E.defectNorm t₂ ≤ E.budget := by
    have h₂abs : |E.defectNorm t₂| ≤ E.budget := habs t₂
    have h₂left : -E.budget ≤ E.defectNorm t₂ := (abs_le.mp h₂abs).1
    linarith
  linarith

end Gibbs.ContinuumField.NavierStokes
