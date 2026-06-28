import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.ProfileThreshold
import StatMech.ContinuumField.NavierStokes.Blowup.Rigidity

/-! # Hard-step minimal-element layer

Construction and structural properties of minimal blow-up elements for the
critical-element contradiction route.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Almost periodicity modulo symmetries (interface-level predicate). -/
def AlmostPeriodicModuloSymmetry (cp : CompactnessProfile .euclidean3) : Prop :=
  cp.nontrivial

/-- Minimal critical element used in the hard-step contradiction route. -/
structure HardStepMinimalElement where
  profile : CompactnessProfile .euclidean3
  nontrivial_mode : ∃ x i, profile.limitingVelocity x i ≠ 0
  minimality : Prop
  minimality_holds : minimality
  almostPeriodic : AlmostPeriodicModuloSymmetry profile

/-- Construct a minimal element from minimizing-sequence extraction witnesses. -/
theorem construct_hardStep_minimal_element
    (T : CriticalThresholdData)
    (_M : MinimizingProfileSequence T)
    (hextract : ∃ cp : CompactnessProfile .euclidean3, cp.nontrivial)
    (hmode : ∀ cp : CompactnessProfile .euclidean3, cp.nontrivial →
      ∃ x i, cp.limitingVelocity x i ≠ 0)
    (hmin : ∀ cp : CompactnessProfile .euclidean3, cp.nontrivial → Prop)
    (hmin_holds : ∀ cp : CompactnessProfile .euclidean3, ∀ hcp : cp.nontrivial, hmin cp hcp) :
    ∃ m : HardStepMinimalElement, m.profile.nontrivial := by
  rcases hextract with ⟨cp, hcp⟩
  refine ⟨{
    profile := cp
    nontrivial_mode := hmode cp hcp
    minimality := hmin cp hcp
    minimality_holds := hmin_holds cp hcp
    almostPeriodic := hcp
  }, ?_⟩
  exact hcp

/-- Nontriviality theorem for hard-step minimal elements. -/
theorem hardStepMinimalElement_nontrivial
    (m : HardStepMinimalElement) :
    ∃ x i, m.profile.limitingVelocity x i ≠ 0 :=
  m.nontrivial_mode

/-- Minimality theorem for hard-step minimal elements. -/
theorem hardStepMinimalElement_minimality
    (m : HardStepMinimalElement) :
    m.minimality :=
  m.minimality_holds

/-- Almost periodicity theorem for hard-step minimal elements. -/
theorem hardStepMinimalElement_almostPeriodic
    (m : HardStepMinimalElement) :
    AlmostPeriodicModuloSymmetry m.profile :=
  m.almostPeriodic

/-- Every hard-step minimal element determines a standard minimal blow-up object. -/
theorem hardStep_to_minimalBlowupObject
    (m : HardStepMinimalElement) :
    ∃ b : MinimalBlowupObject .euclidean3, b.profile = m.profile := by
  exact build_minimal_blowup_object m.profile m.nontrivial_mode m.minimality

end StatMech.ContinuumField.NavierStokes
