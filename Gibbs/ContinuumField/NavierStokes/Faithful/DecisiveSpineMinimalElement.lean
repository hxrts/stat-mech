import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineProfile

/-! # Decisive contradiction-spine minimal element layer

Minimal-element existence/nontriviality/almost-periodicity results.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Minimal blow-up element existence theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_exists
    (minimal_element : HardStepMinimalElement) :
    ∃ m : HardStepMinimalElement,
      m.profile.nontrivial ∧
      AlmostPeriodicModuloSymmetry m.profile := by
  exact fullProof_exact_minimal_element_exists minimal_element

/-- Minimal-element nontriviality theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_nontrivial
    (minimal_element : HardStepMinimalElement) :
    ∃ x i,
      minimal_element.profile.limitingVelocity x i ≠ 0 := by
  exact minimal_element.nontrivial_mode

/-- Almost-periodicity modulus theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_almostPeriodic_modulus
    (minimal_element : HardStepMinimalElement)
    (orbit_compactness_modulus :
      DecisiveOrbitCompactnessModulus minimal_element) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧
      minimal_element.profile.nontrivial := by
  exact decisiveSpine_compactness_mod_symmetry
    minimal_element orbit_compactness_modulus

/-- Minimal-element layer policy marker for decisive spine. -/
def DecisiveSpineMinimalElementPolicy : Prop :=
  ∀ minimal_element : HardStepMinimalElement,
    ∃ x i, minimal_element.profile.limitingVelocity x i ≠ 0

/-- Minimal-element policy theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_policy :
    DecisiveSpineMinimalElementPolicy := by
  intro minimal_element
  exact decisiveSpine_minimal_element_nontrivial minimal_element

end Gibbs.ContinuumField.NavierStokes
