import Gibbs.ContinuumField.NavierStokes.Blowup.Extraction

/-!
# Blow-up compactness scaffolding

Profile/compactness interfaces used for contradiction-style blow-up analysis.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Compactness profile extracted from a blow-up sequence. -/
structure CompactnessProfile (D : SpatialDomain3) where
  /-- Limiting velocity profile. -/
  limitingVelocity : VelocityField D
  /-- Limiting pressure profile. -/
  limitingPressure : PressureField D
  /-- Nontriviality side condition placeholder. -/
  nontrivial : Prop

/-- Abstract extraction theorem interface from a blow-up sequence. -/
theorem extract_compact_profile {D : SpatialDomain3}
    (_seq : BlowupSequence D)
    (hextract : ∃ cp : CompactnessProfile D, cp.nontrivial) :
    ∃ cp : CompactnessProfile D, cp.nontrivial :=
  hextract

end Gibbs.ContinuumField.NavierStokes
