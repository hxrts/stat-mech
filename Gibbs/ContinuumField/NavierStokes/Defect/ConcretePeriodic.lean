import Gibbs.ContinuumField.NavierStokes.Defect.Estimates
import Gibbs.ContinuumField.NavierStokes.Functional.ConcretePeriodic

/-!
# Concrete periodic defect envelope layer

Concrete envelope objects and differential-inequality consequences for the
periodic Clay target `(B)`.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Concrete periodic critical norm package for defect-envelope closure. -/
def periodicDefectCriticalNorm : CriticalNorm .torus3 where
  target := .L3
  value := periodicCriticalNorm
  nonneg := periodicCriticalNorm_nonneg

/-- Predicate: envelope matches the canonical periodic critical-scaling target. -/
def IsCanonicalPeriodicScalingEnvelope (E : DefectEnvelope .torus3) : Prop :=
  E.criticalNorm.target = .L3

/-- Constructor for concrete periodic envelopes with explicit budgets/control functions. -/
def mkPeriodicDefectEnvelope
    (defectBudget criticalBudget : ℝ)
    (hdefectBudget : 0 ≤ defectBudget)
    (hcriticalBudget : 0 ≤ criticalBudget)
    (defectNorm : ℝ → ℝ)
    (resolvedCriticalNorm : ℝ → ℝ)
    (hdefect : ∀ t, defectNorm t ≤ defectBudget)
    (hcritical : ∀ t, resolvedCriticalNorm t ≤ criticalBudget) :
    DefectEnvelope .torus3 where
  criticalNorm := periodicDefectCriticalNorm
  defectBudget := defectBudget
  criticalBudget := criticalBudget
  defectBudget_nonneg := hdefectBudget
  criticalBudget_nonneg := hcriticalBudget
  defectNorm := defectNorm
  resolvedCriticalNorm := resolvedCriticalNorm
  defect_controlled := hdefect
  critical_controlled := hcritical

/-- The concrete periodic envelope constructor is canonically scaling-compatible. -/
theorem mkPeriodicDefectEnvelope_is_canonical
    (defectBudget criticalBudget : ℝ)
    (hdefectBudget : 0 ≤ defectBudget)
    (hcriticalBudget : 0 ≤ criticalBudget)
    (defectNorm : ℝ → ℝ)
    (resolvedCriticalNorm : ℝ → ℝ)
    (hdefect : ∀ t, defectNorm t ≤ defectBudget)
    (hcritical : ∀ t, resolvedCriticalNorm t ≤ criticalBudget) :
    IsCanonicalPeriodicScalingEnvelope
      (mkPeriodicDefectEnvelope defectBudget criticalBudget hdefectBudget hcriticalBudget
        defectNorm resolvedCriticalNorm hdefect hcritical) := by
  rfl

/-- Concrete periodic differential-inequality wrapper for closure arguments. -/
theorem periodic_differential_inequality_uniform_bound
    (E : DefectEnvelope .torus3)
    (hscaling : IsCanonicalPeriodicScalingEnvelope E)
    (C : EnvelopeDifferentialControl E) :
    ∀ t, C.dDefect t ≤ C.alpha * E.criticalBudget + C.beta := by
  intro t
  have _ : E.criticalNorm.target = .L3 := hscaling
  exact differential_control_uniform_bound E C t

end Gibbs.ContinuumField.NavierStokes
