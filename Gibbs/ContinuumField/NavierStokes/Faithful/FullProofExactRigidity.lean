import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactCompactness
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomRigidity

/-! # Full proof exact rigidity theorem

Rigidity ingredients and contradiction theorem in the exact critical route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact rigidity data for the full-proof route. -/
structure FullProofExactRigidityData where
  compactness : FullProofExactCompactnessData
  rigidity : BaseAxiomPrimitiveRigidity compactness.compactness

/-- Exact local-energy and epsilon-regularity theorem package. -/
theorem fullProof_exact_localEnergy_epsilonRegularity
    (R : FullProofExactRigidityData) :
    (∀ t u, 0 ≤ R.rigidity.local_energy.localEnergy t u) ∧
    (∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ R.rigidity.local_energy.epsilon →
        R.rigidity.local_energy.epsilon_regularity u) := by
  exact baseAxiom_local_energy_epsilon_regularity R.rigidity

/-- Exact lower/upper quantitative theorem package. -/
theorem fullProof_exact_lower_upper_quantitative
    (R : FullProofExactRigidityData) :
    (∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 R.rigidity.trajectory|) ∧
    (TendsToZeroNat (fun N => scaleFlux N R.rigidity.lower_flux.t0 R.rigidity.trajectory) ∧
      TendsToZeroNat R.rigidity.upper_tail.integratedDefect) := by
  exact ⟨baseAxiom_lower_cascade_from_minimality R.rigidity,
    baseAxiom_upper_tail_vanishing R.rigidity⟩

/-- Exact contradiction theorem for the full-proof route. -/
theorem fullProof_exact_rigidity_contradiction
    (R : FullProofExactRigidityData) :
    False := by
  exact baseAxiom_flux_barrier_contradiction R.rigidity

end Gibbs.ContinuumField.NavierStokes
