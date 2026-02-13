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

/-- Quantitative lower mechanism theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_quantitative
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact minimal_element_forces_persistent_cascade m U lower_flux

/-- Lower-mechanism persistence theorem across extracted scale route. -/
theorem decisiveSpine_lower_mechanism_persistence
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (lower_flux : PersistentCascadeWitness m U) :
    DecisiveSpineLowerFluxHypotheses U lower_flux.t0 := by
  refine ⟨lower_flux.η, lower_flux.η_pos, lower_flux.N0, ?_⟩
  intro N hNN
  exact lower_flux.persistent_flux N hNN

/-- Lower-mechanism policy marker for decisive spine. -/
def DecisiveSpineLowerMechanismPolicy : Prop :=
  ∀ {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3},
      (lower_flux : PersistentCascadeWitness m U) →
        DecisiveSpineLowerFluxHypotheses U lower_flux.t0

/-- Lower-mechanism policy theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_policy :
    DecisiveSpineLowerMechanismPolicy := by
  intro m U lower_flux
  exact decisiveSpine_lower_mechanism_persistence lower_flux

end Gibbs.ContinuumField.NavierStokes
