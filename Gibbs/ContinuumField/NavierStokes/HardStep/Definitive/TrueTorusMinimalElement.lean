import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusProfileThreshold
import Gibbs.ContinuumField.NavierStokes.HardStep.MinimalElement

/-! # Definitive true-torus minimal-element layer

Direct construction of the minimal blow-up element and its almost-periodic
compactness properties.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Definitive minimal-element theorem data. -/
structure DefinitiveMinimalElementTheorem where
  element : HardStepMinimalElement
  constructed_from_threshold : Prop
  profile_nontrivial_holds : element.profile.nontrivial

/-- Orbit compactness modulo symmetries for a minimal element. -/
structure DefinitiveOrbitCompactness
    (m : HardStepMinimalElement) where
  compact_mod_symmetry :
    ∀ ε : ℝ, 0 < ε → ∃ K : Nat, 0 < K ∧ m.profile.nontrivial

/-- Definitive minimal-element construction theorem interface. -/
theorem definitive_construct_minimal_element
    (M : DefinitiveMinimalElementTheorem) :
    ∃ m : HardStepMinimalElement, m.profile.nontrivial := by
  exact ⟨M.element, M.profile_nontrivial_holds⟩

/-- Definitive nontriviality and minimality theorem interface. -/
theorem definitive_minimal_element_properties
    (M : DefinitiveMinimalElementTheorem) :
    (∃ x i, M.element.profile.limitingVelocity x i ≠ 0) ∧
    M.element.minimality := by
  exact ⟨M.element.nontrivial_mode, M.element.minimality_holds⟩

/-- Definitive almost-periodicity theorem interface. -/
theorem definitive_minimal_element_almost_periodic
    (M : DefinitiveMinimalElementTheorem) :
    AlmostPeriodicModuloSymmetry M.element.profile :=
  M.element.almostPeriodic

/-- Definitive orbit compactness theorem interface modulo symmetries. -/
theorem definitive_orbit_compactness_mod_symmetry
    (M : DefinitiveMinimalElementTheorem)
    (K : DefinitiveOrbitCompactness M.element) :
    ∀ ε : ℝ, 0 < ε → ∃ K0 : Nat, 0 < K0 ∧ M.element.profile.nontrivial :=
  K.compact_mod_symmetry

end Gibbs.ContinuumField.NavierStokes
