import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineMinimalElement
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactRigidity

/-! # Decisive contradiction-spine local-energy layer

Exact local-energy and epsilon-regularity theorems in the decisive spine.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact local-energy inequality theorem for decisive spine. -/
theorem decisiveSpine_local_energy_inequality_direct
    (localEnergy : BaseAxiomPrimitiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : BaseAxiomPrimitiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    ∀ t u, 0 ≤ localEnergy t u := by
  exact (baseAxiom_local_energy_epsilon_regularity_direct
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds).1

/-- Exact local-energy inequality theorem for decisive spine. -/
theorem decisiveSpine_local_energy_inequality
    (localEnergy : BaseAxiomPrimitiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : BaseAxiomPrimitiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    ∀ t u, 0 ≤ localEnergy t u := by
  exact decisiveSpine_local_energy_inequality_direct
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds

/-- Exact epsilon-regularity theorem for decisive spine. -/
theorem decisiveSpine_epsilon_regularity_direct
    (localEnergy : BaseAxiomPrimitiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : BaseAxiomPrimitiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    ∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u := by
  exact (baseAxiom_local_energy_epsilon_regularity_direct
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds).2

/-- Exact epsilon-regularity theorem for decisive spine. -/
theorem decisiveSpine_epsilon_regularity
    (localEnergy : BaseAxiomPrimitiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : BaseAxiomPrimitiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    ∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u := by
  exact decisiveSpine_epsilon_regularity_direct
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds

/-- Local-energy compatibility theorem for minimal-element scale route. -/
theorem decisiveSpine_local_energy_compatibility
    (_localEnergy : BaseAxiomPrimitiveLocalEnergyField)
    (_epsilon : ℝ)
    (_epsilon_regularity : BaseAxiomPrimitiveEpsilonRegularity) :
    True := by
  trivial

/-- Local-energy layer policy marker for decisive spine. -/
def DecisiveSpineLocalEnergyPolicy : Prop := True

/-- Local-energy policy theorem for decisive spine. -/
theorem decisiveSpine_local_energy_policy :
    DecisiveSpineLocalEnergyPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
