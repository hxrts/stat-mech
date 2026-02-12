import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompactness
import Gibbs.ContinuumField.NavierStokes.HardStep.LowerBoundRigidity
import Gibbs.ContinuumField.NavierStokes.HardStep.TailVanishing
import Gibbs.ContinuumField.NavierStokes.HardStep.ContradictionClosure

/-! # Faithful base-axiom rigidity contradiction

Primitive local-energy, lower-cascade, upper-tail, and contradiction statements
for the base-axiom route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Primitive rigidity data in the base-axiom route. -/
structure BaseAxiomPrimitiveLocalEnergy where
  localEnergy : ℝ → TrueTorusVectorField → ℝ
  local_energy_nonneg : ∀ t u, 0 ≤ localEnergy t u
  epsilon : ℝ
  epsilon_pos : 0 < epsilon
  epsilon_regularity : VelocityField .torus3 → Prop
  epsilon_regularity_holds :
    ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ epsilon →
      epsilon_regularity u

/-- Primitive local-energy and epsilon-regularity theorem bundle. -/
theorem baseAxiom_local_energy_epsilon_regularity
    (local_energy : BaseAxiomPrimitiveLocalEnergy) :
    (∀ t u, 0 ≤ local_energy.localEnergy t u) ∧
    (∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ local_energy.epsilon →
        local_energy.epsilon_regularity u) := by
  refine ⟨local_energy.local_energy_nonneg, ?_⟩
  intro u hu
  exact local_energy.epsilon_regularity_holds u hu

/-- Primitive local-energy and epsilon-regularity theorem in direct form. -/
theorem baseAxiom_local_energy_epsilon_regularity_direct
    (local_energy : BaseAxiomPrimitiveLocalEnergy) :
    (∀ t u, 0 ≤ local_energy.localEnergy t u) ∧
    (∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ local_energy.epsilon →
        local_energy.epsilon_regularity u) := by
  refine ⟨local_energy.local_energy_nonneg, ?_⟩
  intro u hu
  exact local_energy.epsilon_regularity_holds u hu

/-- Primitive lower-cascade theorem from minimality/nontriviality data. -/
theorem baseAxiom_lower_cascade_from_minimality
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact minimal_element_forces_persistent_cascade m U lower_flux

/-- Primitive lower-cascade theorem in direct theorem-argument form. -/
theorem baseAxiom_lower_cascade_from_minimality_direct
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact minimal_element_forces_persistent_cascade m U lower_flux

/-- Primitive upper-tail vanishing theorem from flux/dissipation identities. -/
theorem baseAxiom_upper_tail_vanishing
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitness E U t0) :
    TendsToZeroNat (fun N => scaleFlux N t0 U) ∧
    TendsToZeroNat upper_tail.integratedDefect := by
  exact ⟨scaleFlux_tail_vanishes upper_tail,
    integratedDefect_tail_vanishes upper_tail⟩

/-- Primitive upper-tail vanishing theorem in direct theorem-argument form. -/
theorem baseAxiom_upper_tail_vanishing_direct
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitness E U t0) :
    TendsToZeroNat (fun N => scaleFlux N t0 U) ∧
    TendsToZeroNat upper_tail.integratedDefect := by
  exact ⟨scaleFlux_tail_vanishes upper_tail,
    integratedDefect_tail_vanishes upper_tail⟩

/-- Primitive contradiction theorem from lower-cascade and upper-tail estimates. -/
theorem baseAxiom_flux_barrier_contradiction
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    False := by
  exact hardStep_flux_barrier_contradiction lower_flux upper_tail

/-- Primitive contradiction theorem in direct theorem-argument form. -/
theorem baseAxiom_flux_barrier_contradiction_direct
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    False := by
  exact hardStep_flux_barrier_contradiction lower_flux upper_tail

/-- Primitive all-minimal exclusion consequence used by global-control derivation. -/
theorem baseAxiom_excludes_all_minimal_elements
    (flux_package : HardStepFluxContradictionPackage) :
    ∀ _m : HardStepMinimalElement, False := by
  exact hardStep_global_closure_of_flux_barrier flux_package

/-- Primitive all-minimal exclusion in direct theorem-argument form. -/
theorem baseAxiom_excludes_all_minimal_elements_direct
    (flux_package : HardStepFluxContradictionPackage) :
    ∀ _m : HardStepMinimalElement, False := by
  exact hardStep_global_closure_of_flux_barrier flux_package

/-- Primitive global-closure consequence from the base-axiom rigidity data. -/
theorem baseAxiom_global_closure_from_primitive_rigidity
    (flux_package : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  exact hardStep_global_closure_of_flux_barrier flux_package

/-- Primitive global-closure consequence in direct theorem-argument form. -/
theorem baseAxiom_global_closure_from_flux_package
    (flux_package : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  exact hardStep_global_closure_of_flux_barrier flux_package

end Gibbs.ContinuumField.NavierStokes
