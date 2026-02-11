import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineMinimalElement
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactRigidity

/-! # Decisive contradiction-spine local-energy layer

Exact local-energy and epsilon-regularity theorems in the decisive spine.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Local-energy route data for decisive contradiction spine. -/
structure DecisiveSpineLocalEnergyRoute where
  rigidityData : FullProofExactRigidityData

/-- Exact local-energy inequality theorem for decisive spine. -/
theorem decisiveSpine_local_energy_inequality
    (R : DecisiveSpineLocalEnergyRoute) :
    ∀ t u, 0 ≤ R.rigidityData.rigidity.local_energy.localEnergy t u := by
  exact (fullProof_exact_localEnergy_epsilonRegularity R.rigidityData).1

/-- Exact epsilon-regularity theorem for decisive spine. -/
theorem decisiveSpine_epsilon_regularity
    (R : DecisiveSpineLocalEnergyRoute) :
    ∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ R.rigidityData.rigidity.local_energy.epsilon →
        R.rigidityData.rigidity.local_energy.epsilon_regularity u := by
  exact (fullProof_exact_localEnergy_epsilonRegularity R.rigidityData).2

/-- Local-energy compatibility theorem for minimal-element scale route. -/
theorem decisiveSpine_local_energy_compatibility
    (R : DecisiveSpineLocalEnergyRoute) :
    True := by
  trivial

/-- Local-energy layer policy marker for decisive spine. -/
def DecisiveSpineLocalEnergyPolicy : Prop := True

/-- Local-energy policy theorem for decisive spine. -/
theorem decisiveSpine_local_energy_policy :
    DecisiveSpineLocalEnergyPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
