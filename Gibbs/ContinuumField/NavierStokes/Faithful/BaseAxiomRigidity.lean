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

/-! ## Local energy and epsilon regularity -/

/-- Primitive local-energy functional shape for the base-axiom route. -/
abbrev BaseAxiomPrimitiveLocalEnergyField := ℝ → TrueTorusVectorField → ℝ

/-- Primitive epsilon-regularity predicate shape for the base-axiom route. -/
abbrev BaseAxiomPrimitiveEpsilonRegularity := VelocityField .torus3 → Prop

/-- Primitive local-energy and epsilon-regularity theorem bundle. -/
theorem baseAxiom_local_energy_epsilon_regularity
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
  refine ⟨local_energy_nonneg, ?_⟩
  intro u hu
  exact epsilon_regularity_holds u hu

/-! ## Lower cascade theorems -/

/-- Primitive lower-cascade theorem from minimality/nontriviality data. -/
theorem baseAxiom_lower_cascade_from_minimality
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact minimal_element_forces_persistent_cascade m U lower_flux

/-! ## Upper tail vanishing -/

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

/-! ## Contradiction theorems -/

/-- Primitive contradiction theorem from lower-cascade and upper-tail estimates. -/
theorem baseAxiom_flux_barrier_contradiction
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    False := by
  exact hardStep_quantitative_flux_incompatibility
    lower_flux.η_pos
    (fun N hNN => lower_flux.persistent_flux N hNN)
    (scaleFlux_tail_vanishes upper_tail)

/-! ## Flux hypothesis definitions -/

/-- Direct lower-flux hypothesis shape used in base-axiom rigidity closure. -/
abbrev BaseAxiomLowerFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  ∃ η > (0 : ℝ), ∃ N0 : Nat,
    ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|

/-- Direct upper-flux hypothesis shape used in base-axiom rigidity closure. -/
abbrev BaseAxiomUpperFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  TendsToZeroNat (fun N => scaleFlux N t0 U)

/-- Combined direct lower/upper flux hypotheses for a fixed trajectory. -/
abbrev BaseAxiomLowerUpperFluxHypotheses
    (U : VelocityTrajectory .torus3) : Prop :=
  ∃ t0 : ℝ,
    BaseAxiomLowerFluxHypotheses U t0 ∧
    BaseAxiomUpperFluxHypotheses U t0

/-! ## Global closure from minimal exclusion -/

/-- Direct quantitative contradiction from lower-vs-upper flux hypotheses. -/
theorem baseAxiom_flux_barrier_contradiction_from_hypotheses
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : BaseAxiomLowerFluxHypotheses U t0)
    (upper_hypotheses : BaseAxiomUpperFluxHypotheses U t0) :
    False := by
  rcases lower_hypotheses with ⟨η, hη_pos, N0, hLower⟩
  exact hardStep_quantitative_flux_incompatibility hη_pos hLower upper_hypotheses

/-- Primitive all-minimal exclusion consequence used by global-control derivation. -/
theorem baseAxiom_excludes_all_minimal_elements
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m)) :
    ∀ _m : HardStepMinimalElement, False := by
  intro m
  rcases flux_hypotheses m with ⟨t0, hLower, hUpper⟩
  exact baseAxiom_flux_barrier_contradiction_from_hypotheses hLower hUpper

/-- Primitive global-closure consequence from the base-axiom rigidity data. -/
theorem baseAxiom_global_closure_from_primitive_rigidity
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m)) :
    HardStepGlobalClosure := by
  exact baseAxiom_excludes_all_minimal_elements trajectoryOf flux_hypotheses

end Gibbs.ContinuumField.NavierStokes
