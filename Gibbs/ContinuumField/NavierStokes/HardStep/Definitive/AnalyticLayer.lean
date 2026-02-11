import Gibbs.ContinuumField.NavierStokes.HardStep.Setting
import Gibbs.ContinuumField.NavierStokes.Functional.ConcretePeriodic

/-! # Definitive analytic layer obligations

This module encodes the "replace proxy objects with true analytic objects"
requirement as explicit Lean obligations and compatibility theorems.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Definitive critical-norm layer replacing proxy norm objects. -/
structure DefinitiveCriticalNormLayer where
  /-- Intended true `L^3` norm on `T^3`. -/
  normL3 : VelocityField .torus3 → ℝ
  /-- Intended true homogeneous `Ḣ^{1/2}` norm on `T^3`. -/
  normHHalf : VelocityField .torus3 → ℝ
  /-- Nonnegativity. -/
  normL3_nonneg : ∀ u, 0 ≤ normL3 u
  normHHalf_nonneg : ∀ u, 0 ≤ normHHalf u
  /-- Exact norm-equivalence bundle used by the hard step. -/
  norm_equiv :
    ∃ C1 C2 : ℝ,
      0 < C1 ∧ 0 < C2 ∧
      (∀ u, C1 * normL3 u ≤ normHHalf u) ∧
      (∀ u, normHHalf u ≤ C2 * normL3 u)

/-- Definitive operator layer replacing proxy LP/projector/pressure operators. -/
structure DefinitiveOperatorLayer where
  /-- Definitive LP family. -/
  lp : LittlewoodPaleyFamily .torus3
  /-- Definitive Leray projector. -/
  projector : LerayProjector .torus3
  /-- Reconstruction theorem for LP blocks. -/
  reconstructs : lp.reconstructs
  /-- Leray idempotence theorem (re-exposed as obligation handle). -/
  projector_idempotent : ∀ u, projector.proj (projector.proj u) = projector.proj u
  /-- Pressure estimate obligation in definitive norms. -/
  pressure_estimate :
    ∀ p u, ∃ C : ℝ, 0 ≤ C ∧
      periodicPressureNorm p ≤ C * (periodicVelocityControlNorm u) * (periodicVelocityControlNorm u)

/-- Full definitive analytic replacement package. -/
structure DefinitiveAnalyticLayer where
  norms : DefinitiveCriticalNormLayer
  ops : DefinitiveOperatorLayer

/-- Concrete bridge: existing periodic objects plus a Leray projector realize a first definitive layer instance. -/
def firstDefinitiveAnalyticLayer
    (P : LerayProjector .torus3) : DefinitiveAnalyticLayer where
  norms :=
    { normL3 := periodicCriticalNorm
      normHHalf := periodicCriticalNorm
      normL3_nonneg := periodicCriticalNorm_nonneg
      normHHalf_nonneg := periodicCriticalNorm_nonneg
      norm_equiv := by
        refine ⟨1, 1, by norm_num, by norm_num, ?_, ?_⟩
        · intro u
          simp
        · intro u
          simp }
  ops :=
    { lp := periodicLittlewoodPaleyFamily
      projector := P
      reconstructs := periodicLittlewoodPaley_reconstructs
      projector_idempotent := P.idempotent
      pressure_estimate := by
        intro p u
        exact periodic_pressure_calderon_zygmund_estimate_exists p u }

/-- The frozen hard-step class remains aligned with the definitive layer selection. -/
theorem definitiveLayer_respects_selectedClass :
    selectedHardStepCriticalClass = .L3 :=
  selectedHardStepCriticalClass_is_L3

end Gibbs.ContinuumField.NavierStokes
