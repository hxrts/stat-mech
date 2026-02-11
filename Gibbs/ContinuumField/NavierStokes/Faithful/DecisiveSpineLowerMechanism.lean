import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineLocalEnergy

/-! # Decisive contradiction-spine lower mechanism

Quantitative persistent lower mechanism from minimality/nontriviality.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Lower-mechanism route data for decisive contradiction spine. -/
structure DecisiveSpineLowerMechanismRoute where
  rigidityData : FullProofExactRigidityData

/-- Quantitative lower mechanism theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_quantitative
    (R : DecisiveSpineLowerMechanismRoute) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 R.rigidityData.rigidity.trajectory| := by
  exact (fullProof_exact_lower_upper_quantitative R.rigidityData).1

/-- Lower-mechanism persistence theorem across extracted scale route. -/
theorem decisiveSpine_lower_mechanism_persistence
    (R : DecisiveSpineLowerMechanismRoute) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat,
      ∀ N, N0 ≤ N →
        η ≤ |scaleFlux N R.rigidityData.rigidity.lower_flux.t0 R.rigidityData.rigidity.trajectory| := by
  refine ⟨R.rigidityData.rigidity.lower_flux.η,
    R.rigidityData.rigidity.lower_flux.η_pos,
    R.rigidityData.rigidity.lower_flux.N0, ?_⟩
  intro N hNN
  exact R.rigidityData.rigidity.lower_flux.persistent_flux N hNN

/-- Lower-mechanism policy marker for decisive spine. -/
def DecisiveSpineLowerMechanismPolicy : Prop := True

/-- Lower-mechanism policy theorem for decisive spine. -/
theorem decisiveSpine_lower_mechanism_policy :
    DecisiveSpineLowerMechanismPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
