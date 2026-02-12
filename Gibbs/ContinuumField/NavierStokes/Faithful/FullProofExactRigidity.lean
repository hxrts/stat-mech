import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactCompactness
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomRigidity

/-! # Full proof exact rigidity theorem

Rigidity ingredients and contradiction theorem in the exact critical route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact local-energy and epsilon-regularity theorem package. -/
theorem fullProof_exact_localEnergy_epsilonRegularity_direct
    (localEnergy : BaseAxiomPrimitiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : BaseAxiomPrimitiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    (∀ t u, 0 ≤ localEnergy t u) ∧
    (∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) := by
  exact baseAxiom_local_energy_epsilon_regularity_direct
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds

/-- Exact local-energy and epsilon-regularity theorem package. -/
theorem fullProof_exact_localEnergy_epsilonRegularity
    (localEnergy : BaseAxiomPrimitiveLocalEnergyField)
    (epsilon : ℝ)
    (epsilon_regularity : BaseAxiomPrimitiveEpsilonRegularity)
    (local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u)
    (epsilon_regularity_holds :
      ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) :
    (∀ t u, 0 ≤ localEnergy t u) ∧
    (∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ epsilon →
        epsilon_regularity u) := by
  exact fullProof_exact_localEnergy_epsilonRegularity_direct
    localEnergy epsilon epsilon_regularity local_energy_nonneg epsilon_regularity_holds

/-- Exact lower/upper quantitative theorem package. -/
theorem fullProof_exact_lower_upper_quantitative_direct
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness
      E
      U
      lower_flux.t0) :
    (∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|) ∧
    (TendsToZeroNat (fun N => scaleFlux N lower_flux.t0 U) ∧
      TendsToZeroNat upper_tail.integratedDefect) := by
  exact ⟨baseAxiom_lower_cascade_from_minimality_direct lower_flux,
    baseAxiom_upper_tail_vanishing_direct upper_tail⟩

/-- Exact lower/upper quantitative theorem package. -/
theorem fullProof_exact_lower_upper_quantitative
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    (∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|) ∧
    (TendsToZeroNat (fun N => scaleFlux N lower_flux.t0 U) ∧
      TendsToZeroNat upper_tail.integratedDefect) := by
  exact fullProof_exact_lower_upper_quantitative_direct lower_flux upper_tail

/-- Exact contradiction theorem for the full-proof route. -/
theorem fullProof_exact_rigidity_contradiction_direct
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness
      E
      U
      lower_flux.t0) :
    False := by
  exact baseAxiom_flux_barrier_contradiction_direct lower_flux upper_tail

/-- Exact contradiction theorem for the full-proof route. -/
theorem fullProof_exact_rigidity_contradiction
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    False := by
  exact fullProof_exact_rigidity_contradiction_direct lower_flux upper_tail

end Gibbs.ContinuumField.NavierStokes
