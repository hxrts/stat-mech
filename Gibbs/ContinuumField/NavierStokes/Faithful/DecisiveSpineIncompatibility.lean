import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineUpperMechanism

/-! # Decisive contradiction-spine incompatibility theorem

Single decisive contradiction theorem and threshold-unbounded corollaries.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical lower-hypothesis shape for the decisive crux theorem. -/
abbrev DecisiveSpineLowerHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  DecisiveSpineLowerFluxHypotheses U t0

/-- Canonical upper-hypothesis shape for the decisive crux theorem. -/
abbrev DecisiveSpineUpperHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  DecisiveSpineUpperFluxHypotheses U t0

/-- Direct crux theorem: explicit lower/upper hypotheses imply contradiction. -/
theorem decisiveSpine_crux_incompatibility
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypotheses U t0)
    (upper_hypotheses : DecisiveSpineUpperHypotheses U t0) :
    False := by
  rcases lower_hypotheses with ⟨η, hη_pos, N0, hpersistent⟩
  have htwo_pos : 0 < (2 : ℝ) := by norm_num
  have hhalf_pos : 0 < η / 2 := div_pos hη_pos htwo_pos
  rcases upper_hypotheses (η / 2) hhalf_pos with ⟨N1, hN1⟩
  let N : Nat := max N0 N1
  have hlow : η ≤ |scaleFlux N t0 U| :=
    hpersistent N (le_max_left _ _)
  have hhigh : |scaleFlux N t0 U| ≤ η / 2 :=
    hN1 N (le_max_right _ _)
  have hη_half : η ≤ η / 2 := le_trans hlow hhigh
  exact (not_le_of_gt (half_lt_self hη_pos)) hη_half

/-- Decisive incompatibility theorem: lower + upper mechanisms imply contradiction. -/
theorem decisiveSpine_incompatibility_theorem
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypotheses U t0)
    (upper_hypotheses : DecisiveSpineUpperHypotheses U t0) :
    False := by
  exact decisiveSpine_crux_incompatibility
    lower_hypotheses
    upper_hypotheses

/-- Witness-to-hypothesis bridge for incompatibility route. -/
theorem decisiveSpine_incompatibility_from_witness
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    False := by
  refine decisiveSpine_incompatibility_theorem
    (U := U) (t0 := lower_flux.t0) ?_ ?_
  · exact decisiveSpine_lower_mechanism_persistence lower_flux
  · exact (decisiveSpine_upper_mechanism_quantitative upper_tail).1

/-- Corollary excluding minimal blow-up elements in decisive spine route. -/
theorem decisiveSpine_excludes_all_minimal_elements
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypotheses U t0)
    (upper_hypotheses : DecisiveSpineUpperHypotheses U t0) :
    ∀ _ : HardStepMinimalElement, False := by
  intro _m
  exact False.elim (decisiveSpine_incompatibility_theorem lower_hypotheses upper_hypotheses)

/-- Threshold-unbounded proxy statement for decisive spine route. -/
def DecisiveSpineAstarInfinite
    (threshold : BaseAxiomPrimitiveThresholdData) : Prop :=
  ∀ B : ℝ, 0 ≤ B → B ≤ baseAxiomAstar threshold

/-- Corollary threshold-unbounded theorem from decisive incompatibility route. -/
theorem decisiveSpine_Astar_infinite
    (threshold : BaseAxiomPrimitiveThresholdData)
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypotheses U t0)
    (upper_hypotheses : DecisiveSpineUpperHypotheses U t0) :
    DecisiveSpineAstarInfinite threshold := by
  intro B hB
  exact False.elim (decisiveSpine_incompatibility_theorem lower_hypotheses upper_hypotheses)

/-- Incompatibility-layer policy marker for decisive spine. -/
def DecisiveSpineIncompatibilityPolicy : Prop := True

/-- Incompatibility policy theorem for decisive spine. -/
theorem decisiveSpine_incompatibility_policy :
    DecisiveSpineIncompatibilityPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
