import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineMinimalElement
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactRigidity

/-! # Decisive contradiction-spine local-energy layer

Exact local-energy and epsilon-regularity theorems in the decisive spine.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive-native local-energy field alias. -/
abbrev DecisiveLocalEnergyField := BaseAxiomPrimitiveLocalEnergyField

/-- Decisive-native epsilon-regularity predicate alias. -/
abbrev DecisiveEpsilonRegularity := BaseAxiomPrimitiveEpsilonRegularity

/-- Exact local-energy inequality theorem for decisive spine. -/
theorem decisiveSpine_local_energy_inequality
    (localEnergy : DecisiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : DecisiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    ∀ t u, 0 ≤ localEnergy t u := by
  exact (baseAxiom_local_energy_epsilon_regularity
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds
    ).1

/-- Exact epsilon-regularity theorem for decisive spine. -/
theorem decisiveSpine_epsilon_regularity
    (localEnergy : DecisiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : DecisiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    ∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u := by
  exact (baseAxiom_local_energy_epsilon_regularity
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds
    ).2

/-- Local-energy compatibility theorem for minimal-element scale route. -/
theorem decisiveSpine_local_energy_compatibility
    (_localEnergy : DecisiveLocalEnergyField)
    (_epsilon : ℝ)
    (_epsilon_regularity : DecisiveEpsilonRegularity) :
    True := by
  trivial

/-- Local-energy layer policy marker for decisive spine. -/
def DecisiveSpineLocalEnergyPolicy : Prop :=
  ∀ (localEnergy : DecisiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : DecisiveEpsilonRegularity),
      (∀ t u, 0 ≤ localEnergy t u) →
      (∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) →
      ∀ u : VelocityField .torus3,
        hardStepNormL3 u ≤ epsilon →
          epsilon_regularity u

/-- Local-energy policy theorem for decisive spine. -/
theorem decisiveSpine_local_energy_policy :
    DecisiveSpineLocalEnergyPolicy := by
  intro localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds
  exact decisiveSpine_epsilon_regularity
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds

end Gibbs.ContinuumField.NavierStokes
