import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusLocalEnergyRegularity
import Gibbs.ContinuumField.NavierStokes.HardStep.LowerBoundRigidity

/-! # Definitive true-torus lower flux rigidity

Lower cascade-activity bounds derived directly from minimality/nontriviality.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct definitive lower-hypothesis shape used by the flux-rigidity crux. -/
abbrev DefinitiveLowerFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  ∃ η > (0 : ℝ), ∃ N0 : Nat,
    ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|

/-- Dyadic definitive lower-hypothesis shape used by the flux-rigidity crux. -/
abbrev DefinitiveLowerFluxHypothesesDyadic
    (F : DyadicErasureFamily .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  ∃ η > (0 : ℝ), ∃ N0 : Nat,
    ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U|

/-- Definitive lower-bound theorem from minimality. -/
theorem definitive_lower_flux_bound
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact minimal_element_forces_persistent_cascade m U lower_flux

/-- Dyadic definitive lower-bound theorem from minimality. -/
theorem definitive_lower_flux_bound_dyadic
    {F : DyadicErasureFamily .torus3}
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitnessDyadic F m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U| := by
  exact minimal_element_forces_persistent_cascade_dyadic F m U lower_flux

/-- Definitive persistence theorem over scale/time windows. -/
theorem definitive_lower_flux_persistence
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    DefinitiveLowerFluxHypotheses U lower_flux.t0 := by
  refine ⟨lower_flux.η, lower_flux.η_pos, lower_flux.N0, ?_⟩
  intro N hNN
  exact lower_flux.persistent_flux N hNN

/-- Dyadic definitive persistence theorem over scale/time windows. -/
theorem definitive_lower_flux_persistence_dyadic
    {F : DyadicErasureFamily .torus3}
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitnessDyadic F m U) :
    DefinitiveLowerFluxHypothesesDyadic F U lower_flux.t0 := by
  refine ⟨lower_flux.η, lower_flux.η_pos, lower_flux.N0, ?_⟩
  intro N hNN
  exact lower_flux.persistent_flux N hNN

/-- Legacy/dyadic identity compatibility for definitive lower hypotheses. -/
theorem definitiveLowerFluxHypotheses_iff_dyadic_identity
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) :
    DefinitiveLowerFluxHypotheses U t0 ↔
      DefinitiveLowerFluxHypothesesDyadic periodicCanonicalDyadicErasureFamily U t0 := by
  constructor
  · rintro ⟨η, hη, N0, hLower⟩
    refine ⟨η, hη, N0, ?_⟩
    intro N hN
    simpa [scaleFlux, scaleFluxDyadic, periodicDyadicDefectObservable,
      periodicDyadicDefectAtScale] using hLower N hN
  · rintro ⟨η, hη, N0, hLower⟩
    refine ⟨η, hη, N0, ?_⟩
    intro N hN
    simpa [scaleFlux, scaleFluxDyadic, periodicDyadicDefectObservable,
      periodicDyadicDefectAtScale] using hLower N hN

end Gibbs.ContinuumField.NavierStokes
