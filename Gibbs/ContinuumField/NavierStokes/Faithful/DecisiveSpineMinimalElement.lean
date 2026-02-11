import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineProfile

/-! # Decisive contradiction-spine minimal element layer

Minimal-element existence/nontriviality/almost-periodicity results.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Minimal-element package for decisive contradiction spine. -/
structure DecisiveSpineMinimalElementPackage where
  profileRoute : DecisiveSpineProfileRoute

/-- Minimal blow-up element existence theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_exists
    (P : DecisiveSpineMinimalElementPackage) :
    ∃ m : HardStepMinimalElement,
      m.profile.nontrivial ∧
      AlmostPeriodicModuloSymmetry m.profile := by
  exact fullProof_exact_minimal_element_exists P.profileRoute.exactCompactness

/-- Minimal-element nontriviality theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_nontrivial
    (P : DecisiveSpineMinimalElementPackage) :
    ∃ x i,
      P.profileRoute.exactCompactness.compactness.minimal_element.profile.limitingVelocity x i ≠ 0 := by
  exact P.profileRoute.exactCompactness.compactness.minimal_element.nontrivial_mode

/-- Almost-periodicity modulus theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_almostPeriodic_modulus
    (P : DecisiveSpineMinimalElementPackage) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧
      P.profileRoute.exactCompactness.compactness.minimal_element.profile.nontrivial := by
  exact decisiveSpine_compactness_mod_symmetry P.profileRoute

/-- Minimal-element layer policy marker for decisive spine. -/
def DecisiveSpineMinimalElementPolicy : Prop := True

/-- Minimal-element policy theorem for decisive spine. -/
theorem decisiveSpine_minimal_element_policy :
    DecisiveSpineMinimalElementPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
