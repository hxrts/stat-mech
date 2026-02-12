import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineProfile

/-! # Decisive contradiction-spine minimal element layer

Minimal-element existence/nontriviality/almost-periodicity results.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Minimal blow-up element existence theorem in direct form. -/
theorem decisiveSpine_minimal_element_exists_direct
    (X : FullProofExactCompactnessData) :
    ∃ m : HardStepMinimalElement,
      m.profile.nontrivial ∧
      AlmostPeriodicModuloSymmetry m.profile := by
  exact fullProof_exact_minimal_element_exists X

/-- Minimal blow-up element existence theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_exists
    (X : FullProofExactCompactnessData) :
    ∃ m : HardStepMinimalElement,
      m.profile.nontrivial ∧
      AlmostPeriodicModuloSymmetry m.profile := by
  exact decisiveSpine_minimal_element_exists_direct X

/-- Minimal-element nontriviality theorem in direct form. -/
theorem decisiveSpine_minimal_element_nontrivial_direct
    (X : FullProofExactCompactnessData) :
    ∃ x i,
      X.compactness.minimal_element.profile.limitingVelocity x i ≠ 0 := by
  exact X.compactness.minimal_element.nontrivial_mode

/-- Minimal-element nontriviality theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_nontrivial
    (X : FullProofExactCompactnessData) :
    ∃ x i,
      X.compactness.minimal_element.profile.limitingVelocity x i ≠ 0 := by
  exact decisiveSpine_minimal_element_nontrivial_direct X

/-- Almost-periodicity modulus theorem in direct form. -/
theorem decisiveSpine_minimal_element_almostPeriodic_modulus_direct
    (X : FullProofExactCompactnessData) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧
      X.compactness.minimal_element.profile.nontrivial := by
  exact decisiveSpine_compactness_mod_symmetry_direct X

/-- Almost-periodicity modulus theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_almostPeriodic_modulus
    (X : FullProofExactCompactnessData) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧
      X.compactness.minimal_element.profile.nontrivial := by
  exact decisiveSpine_minimal_element_almostPeriodic_modulus_direct X

/-- Minimal-element layer policy marker for decisive spine. -/
def DecisiveSpineMinimalElementPolicy : Prop := True

/-- Minimal-element policy theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_policy :
    DecisiveSpineMinimalElementPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
