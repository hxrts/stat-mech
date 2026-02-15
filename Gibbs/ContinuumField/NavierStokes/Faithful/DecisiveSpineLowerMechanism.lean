import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineLocalEnergy

/-! # Decisive contradiction-spine lower mechanism

Quantitative persistent lower mechanism from minimality/nontriviality.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct lower-flux hypothesis shape for the decisive crux step. -/
abbrev DecisiveSpineLowerFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  ∃ η > (0 : ℝ), ∃ N0 : Nat,
    ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|

/-- Dyadic lower-flux hypothesis shape for the decisive crux step. -/
abbrev DecisiveSpineLowerFluxHypothesesDyadic
    (F : DyadicErasureFamily .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  ∃ η > (0 : ℝ), ∃ N0 : Nat,
    ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U|

/-- Quantitative lower mechanism theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_quantitative
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact minimal_element_forces_persistent_cascade m U lower_flux

/-- Dyadic quantitative lower mechanism theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_quantitative_dyadic
    {F : DyadicErasureFamily .torus3}
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitnessDyadic F m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U| := by
  exact minimal_element_forces_persistent_cascade_dyadic F m U lower_flux

/-- Lower-mechanism persistence theorem across extracted scale route. -/
theorem decisiveSpine_lower_mechanism_persistence
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    DecisiveSpineLowerFluxHypotheses U lower_flux.t0 := by
  refine ⟨lower_flux.η, lower_flux.η_pos, lower_flux.N0, ?_⟩
  intro N hNN
  exact lower_flux.persistent_flux N hNN

/-- Dyadic lower-mechanism persistence theorem across extracted scale route. -/
theorem decisiveSpine_lower_mechanism_persistence_dyadic
    {F : DyadicErasureFamily .torus3}
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitnessDyadic F m U) :
    DecisiveSpineLowerFluxHypothesesDyadic F U lower_flux.t0 := by
  refine ⟨lower_flux.η, lower_flux.η_pos, lower_flux.N0, ?_⟩
  intro N hNN
  exact lower_flux.persistent_flux N hNN

/-- Identity-family compatibility for decisive lower hypotheses. -/
theorem decisiveSpineLowerFluxHypotheses_iff_dyadic_identity
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) :
    DecisiveSpineLowerFluxHypotheses U t0 ↔
      DecisiveSpineLowerFluxHypothesesDyadic periodicCanonicalDyadicErasureFamily U t0 := by
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

/-- Lower-mechanism policy marker for decisive spine. -/
def DecisiveSpineLowerMechanismPolicy : Prop :=
  ∀ {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3},
      (lower_flux : PersistentCascadeWitness m U) →
        DecisiveSpineLowerFluxHypotheses U lower_flux.t0

/-- Dyadic lower-mechanism policy marker for decisive spine. -/
def DecisiveSpineLowerMechanismPolicyDyadic : Prop :=
  ∀ {F : DyadicErasureFamily .torus3}
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3},
      (lower_flux : PersistentCascadeWitnessDyadic F m U) →
        DecisiveSpineLowerFluxHypothesesDyadic F U lower_flux.t0

/-- Lower-mechanism policy theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_policy :
    DecisiveSpineLowerMechanismPolicy := by
  intro m U lower_flux
  exact decisiveSpine_lower_mechanism_persistence lower_flux

/-- Dyadic lower-mechanism policy theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_policy_dyadic :
    DecisiveSpineLowerMechanismPolicyDyadic := by
  intro F m U lower_flux
  exact decisiveSpine_lower_mechanism_persistence_dyadic lower_flux

end Gibbs.ContinuumField.NavierStokes
