import StatMech.ContinuumField.NavierStokes.Blowup.Extraction

/-! # Blow-up compactness scaffolding

Profile/compactness interfaces used for contradiction-style blow-up analysis.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Compactness profile extracted from a blow-up sequence. -/
structure CompactnessProfile (D : SpatialDomain3) where
  /-- Limiting velocity profile. -/
  limitingVelocity : VelocityField D
  /-- Limiting pressure profile. -/
  limitingPressure : PressureField D
  /-- Nontriviality side condition placeholder. -/
  nontrivial : Prop

/-- Minimal blow-up object with an explicit nonzero mode witness. -/
structure MinimalBlowupObject (D : SpatialDomain3) where
  /-- Underlying compactness profile. -/
  profile : CompactnessProfile D
  /-- Concrete nontriviality witness for the limiting velocity. -/
  nonzero_mode : ∃ x i, profile.limitingVelocity x i ≠ 0
  /-- Minimality side condition for concentration/compactness arguments. -/
  minimality : Prop

/-- Abstract extraction theorem interface from a blow-up sequence. -/
theorem extract_compact_profile {D : SpatialDomain3}
    (_seq : BlowupSequence D)
    (hextract : ∃ cp : CompactnessProfile D, cp.nontrivial) :
    ∃ cp : CompactnessProfile D, cp.nontrivial :=
  hextract

/-- Constructor theorem for a minimal blow-up object from explicit witnesses. -/
theorem build_minimal_blowup_object {D : SpatialDomain3}
    (cp : CompactnessProfile D)
    (hmode : ∃ x i, cp.limitingVelocity x i ≠ 0)
    (hmin : Prop) :
    ∃ m : MinimalBlowupObject D, m.profile = cp := by
  refine ⟨{ profile := cp, nonzero_mode := hmode, minimality := hmin }, rfl⟩

end StatMech.ContinuumField.NavierStokes
