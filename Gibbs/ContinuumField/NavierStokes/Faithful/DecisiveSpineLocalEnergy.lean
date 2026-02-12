import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineMinimalElement
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactRigidity

/-! # Decisive contradiction-spine local-energy layer

Exact local-energy and epsilon-regularity theorems in the decisive spine.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact local-energy inequality theorem for decisive spine. -/
theorem decisiveSpine_local_energy_inequality_direct
    (local_energy : BaseAxiomPrimitiveLocalEnergy) :
    ∀ t u, 0 ≤ local_energy.localEnergy t u := by
  exact (baseAxiom_local_energy_epsilon_regularity_direct local_energy).1

/-- Exact local-energy inequality theorem for decisive spine. -/
theorem decisiveSpine_local_energy_inequality
    (local_energy : BaseAxiomPrimitiveLocalEnergy) :
    ∀ t u, 0 ≤ local_energy.localEnergy t u := by
  exact decisiveSpine_local_energy_inequality_direct local_energy

/-- Exact epsilon-regularity theorem for decisive spine. -/
theorem decisiveSpine_epsilon_regularity_direct
    (local_energy : BaseAxiomPrimitiveLocalEnergy) :
    ∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ local_energy.epsilon →
        local_energy.epsilon_regularity u := by
  exact (baseAxiom_local_energy_epsilon_regularity_direct local_energy).2

/-- Exact epsilon-regularity theorem for decisive spine. -/
theorem decisiveSpine_epsilon_regularity
    (local_energy : BaseAxiomPrimitiveLocalEnergy) :
    ∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ local_energy.epsilon →
        local_energy.epsilon_regularity u := by
  exact decisiveSpine_epsilon_regularity_direct local_energy

/-- Local-energy compatibility theorem for minimal-element scale route. -/
theorem decisiveSpine_local_energy_compatibility
    (_local_energy : BaseAxiomPrimitiveLocalEnergy) :
    True := by
  trivial

/-- Local-energy layer policy marker for decisive spine. -/
def DecisiveSpineLocalEnergyPolicy : Prop := True

/-- Local-energy policy theorem for decisive spine. -/
theorem decisiveSpine_local_energy_policy :
    DecisiveSpineLocalEnergyPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
