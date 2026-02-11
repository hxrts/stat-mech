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

 /-- Primitive rigidity data in the base-axiom route. -/
structure BaseAxiomPrimitiveRigidity
    (C : BaseAxiomPrimitiveCompactness) where
  local_energy : BaseAxiomPrimitiveLocalEnergy
  trajectory : VelocityTrajectory .torus3
  envelope : DefectEnvelope .torus3
  lower_flux :
    PersistentCascadeWitness C.minimal_element trajectory
  upper_tail :
    TailVanishingWitness envelope trajectory lower_flux.t0
  flux_package : HardStepFluxContradictionPackage

/-- Primitive local-energy and epsilon-regularity theorem bundle. -/
theorem baseAxiom_local_energy_epsilon_regularity
    {C : BaseAxiomPrimitiveCompactness}
    (R : BaseAxiomPrimitiveRigidity C) :
    (∀ t u, 0 ≤ R.local_energy.localEnergy t u) ∧
    (∀ u : VelocityField .torus3,
      hardStepNormL3 u ≤ R.local_energy.epsilon →
        R.local_energy.epsilon_regularity u) := by
  refine ⟨R.local_energy.local_energy_nonneg, ?_⟩
  intro u hu
  exact R.local_energy.epsilon_regularity_holds u hu

/-- Primitive lower-cascade theorem from minimality/nontriviality data. -/
theorem baseAxiom_lower_cascade_from_minimality
    {C : BaseAxiomPrimitiveCompactness}
    (R : BaseAxiomPrimitiveRigidity C) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 R.trajectory| := by
  exact minimal_element_forces_persistent_cascade
    C.minimal_element R.trajectory R.lower_flux

/-- Primitive upper-tail vanishing theorem from flux/dissipation identities. -/
theorem baseAxiom_upper_tail_vanishing
    {C : BaseAxiomPrimitiveCompactness}
    (R : BaseAxiomPrimitiveRigidity C) :
    TendsToZeroNat (fun N => scaleFlux N R.lower_flux.t0 R.trajectory) ∧
    TendsToZeroNat R.upper_tail.integratedDefect := by
  exact ⟨scaleFlux_tail_vanishes R.upper_tail,
    integratedDefect_tail_vanishes R.upper_tail⟩

/-- Primitive contradiction theorem from lower-cascade and upper-tail estimates. -/
theorem baseAxiom_flux_barrier_contradiction
    {C : BaseAxiomPrimitiveCompactness}
    (R : BaseAxiomPrimitiveRigidity C) :
    False := by
  exact hardStep_flux_barrier_contradiction R.lower_flux R.upper_tail

/-- Primitive all-minimal exclusion consequence used by global-control derivation. -/
theorem baseAxiom_excludes_all_minimal_elements
    {C : BaseAxiomPrimitiveCompactness}
    (R : BaseAxiomPrimitiveRigidity C) :
    ∀ m : HardStepMinimalElement, False := by
  exact hardStep_global_closure_of_flux_barrier R.flux_package

/-- Primitive global-closure consequence from the base-axiom rigidity data. -/
theorem baseAxiom_global_closure_from_primitive_rigidity
    {C : BaseAxiomPrimitiveCompactness}
    (R : BaseAxiomPrimitiveRigidity C) :
    HardStepGlobalClosure := by
  exact hardStep_global_closure_of_flux_barrier R.flux_package

end Gibbs.ContinuumField.NavierStokes
