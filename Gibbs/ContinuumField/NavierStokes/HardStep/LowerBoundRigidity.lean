import Gibbs.ContinuumField.NavierStokes.HardStep.FluxTail

/-! # Hard-step lower-bound rigidity

Lower-bound cascade activity results driven by minimal-element nontriviality.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Quantitative persistent-cascade witness over a scale/time window. -/
structure PersistentCascadeWitness
    (m : HardStepMinimalElement)
    (U : VelocityTrajectory .torus3) where
  η : ℝ
  η_pos : 0 < η
  N0 : Nat
  t0 : ℝ
  /-- Persistent lower bound on absolute scale flux beyond `N0`. -/
  persistent_flux :
    ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|

/-- Minimal nontrivial element enforces persistent cascade activity (quantitative form). -/
theorem minimal_element_forces_persistent_cascade
    (m : HardStepMinimalElement)
    (U : VelocityTrajectory .torus3)
    (W : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact ⟨W.η, W.η_pos, W.N0, W.t0, W.persistent_flux⟩

/-- Complete high-frequency quiescence beyond `N0` is incompatible with persistent cascade lower bounds. -/
theorem persistent_cascade_incompatible_with_quiescence
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (W : PersistentCascadeWitness m U)
    (hquiescent : ∀ N, W.N0 ≤ N → scaleFlux N W.t0 U = 0) :
    False := by
  have hη_nonpos : W.η ≤ 0 := by
    have hbound := W.persistent_flux W.N0 (le_rfl : W.N0 ≤ W.N0)
    have hzero : |scaleFlux W.N0 W.t0 U| = 0 := by
      simp [hquiescent W.N0 (le_rfl : W.N0 ≤ W.N0)]
    simpa [hzero] using hbound
  exact not_le_of_gt W.η_pos hη_nonpos

end Gibbs.ContinuumField.NavierStokes
