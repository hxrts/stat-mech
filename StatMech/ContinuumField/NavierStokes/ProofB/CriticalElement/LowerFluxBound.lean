import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.ScaleFlux

/-! # Hard-step lower-bound rigidity

Lower-bound cascade activity results driven by minimal-element nontriviality.
-/

namespace StatMech.ContinuumField.NavierStokes

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

/-- Dyadic-form quantitative persistent-cascade witness over a scale/time window. -/
structure PersistentCascadeWitnessDyadic
    (F : DyadicErasureFamily .torus3)
    (m : HardStepMinimalElement)
    (U : VelocityTrajectory .torus3) where
  η : ℝ
  η_pos : 0 < η
  N0 : Nat
  t0 : ℝ
  /-- Persistent lower bound on absolute dyadic scale flux beyond `N0`. -/
  persistent_flux :
    ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U|

/-- Bridge: legacy persistent-cascade witness is dyadic for the legacy
identity dyadic family used in `scaleFlux`. -/
def persistentCascadeWitnessDyadic_of_legacy
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (W : PersistentCascadeWitness m U) :
    PersistentCascadeWitnessDyadic periodicCanonicalDyadicErasureFamily m U := by
  refine
    { η := W.η
      η_pos := W.η_pos
      N0 := W.N0
      t0 := W.t0
      persistent_flux := ?_ }
  intro N hN
  simpa [scaleFlux, scaleFluxDyadic, periodicDyadicDefectObservable,
    periodicDyadicDefectAtScale] using W.persistent_flux N hN

/-- Minimal nontrivial element enforces persistent cascade activity (quantitative form). -/
theorem minimal_element_forces_persistent_cascade
    (m : HardStepMinimalElement)
    (U : VelocityTrajectory .torus3)
    (W : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact ⟨W.η, W.η_pos, W.N0, W.t0, W.persistent_flux⟩

/-- Dyadic version: minimal nontrivial element enforces persistent cascade activity. -/
theorem minimal_element_forces_persistent_cascade_dyadic
    (F : DyadicErasureFamily .torus3)
    (m : HardStepMinimalElement)
    (U : VelocityTrajectory .torus3)
    (W : PersistentCascadeWitnessDyadic F m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U| := by
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

/-- Dyadic counterpart: quiescence is incompatible with persistent dyadic cascade lower bounds. -/
theorem persistent_cascade_incompatible_with_quiescence_dyadic
    {F : DyadicErasureFamily .torus3}
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (W : PersistentCascadeWitnessDyadic F m U)
    (hquiescent : ∀ N, W.N0 ≤ N → scaleFluxDyadic F N W.t0 U = 0) :
    False := by
  have hη_nonpos : W.η ≤ 0 := by
    have hbound := W.persistent_flux W.N0 (le_rfl : W.N0 ≤ W.N0)
    have hzero : |scaleFluxDyadic F W.N0 W.t0 U| = 0 := by
      simp [hquiescent W.N0 (le_rfl : W.N0 ≤ W.N0)]
    simpa [hzero] using hbound
  exact not_le_of_gt W.η_pos hη_nonpos

end StatMech.ContinuumField.NavierStokes
