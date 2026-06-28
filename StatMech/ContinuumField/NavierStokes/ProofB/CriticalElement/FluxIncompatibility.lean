import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.UpperFluxMechanism

/-! # Decisive contradiction-spine incompatibility theorem

Single decisive contradiction theorem and threshold-unbounded corollaries.
-/

namespace StatMech.ContinuumField.NavierStokes

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

/-- Dyadic canonical lower-hypothesis shape for the decisive crux theorem. -/
abbrev DecisiveSpineLowerHypothesesDyadic
    (F : DyadicErasureFamily .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  DecisiveSpineLowerFluxHypothesesDyadic F U t0

/-- Dyadic canonical upper-hypothesis shape for the decisive crux theorem. -/
abbrev DecisiveSpineUpperHypothesesDyadic
    (F : DyadicErasureFamily .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  DecisiveSpineUpperFluxHypothesesDyadic F U t0

/-- Direct crux theorem: explicit lower/upper hypotheses imply contradiction. -/
theorem decisiveSpine_crux_incompatibility
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypotheses U t0)
    (upper_hypotheses : DecisiveSpineUpperHypotheses U t0) :
    False := by
  rcases lower_hypotheses with ⟨η, hη_pos, N0, hLower⟩
  exact hardStep_quantitative_flux_incompatibility hη_pos hLower upper_hypotheses

/-- Dyadic direct crux theorem: explicit lower/upper dyadic hypotheses imply contradiction. -/
theorem decisiveSpine_crux_incompatibility_dyadic
    {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypothesesDyadic F U t0)
    (upper_hypotheses : DecisiveSpineUpperHypothesesDyadic F U t0) :
    False := by
  rcases lower_hypotheses with ⟨η, hη_pos, N0, hLower⟩
  exact hardStep_quantitative_flux_incompatibility_dyadic hη_pos hLower upper_hypotheses

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

/-- Dyadic decisive incompatibility theorem: dyadic lower + upper mechanisms imply contradiction. -/
theorem decisiveSpine_incompatibility_theorem_dyadic
    {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypothesesDyadic F U t0)
    (upper_hypotheses : DecisiveSpineUpperHypothesesDyadic F U t0) :
    False := by
  exact decisiveSpine_crux_incompatibility_dyadic lower_hypotheses upper_hypotheses

/-- Corollary excluding minimal blow-up elements in decisive spine route. -/
theorem decisiveSpine_excludes_all_minimal_elements
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypotheses U t0)
    (upper_hypotheses : DecisiveSpineUpperHypotheses U t0) :
    ∀ _ : HardStepMinimalElement, False := by
  intro _m
  exact False.elim (decisiveSpine_incompatibility_theorem lower_hypotheses upper_hypotheses)

/-- Dyadic corollary excluding minimal blow-up elements in decisive spine route. -/
theorem decisiveSpine_excludes_all_minimal_elements_dyadic
    {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypothesesDyadic F U t0)
    (upper_hypotheses : DecisiveSpineUpperHypothesesDyadic F U t0) :
    ∀ _ : HardStepMinimalElement, False := by
  intro _m
  exact False.elim (decisiveSpine_incompatibility_theorem_dyadic lower_hypotheses upper_hypotheses)

/-- Threshold-unbounded proxy statement for decisive spine route. -/
def DecisiveSpineAstarInfinite
    (threshold : DecisiveThresholdData) : Prop :=
  ∀ B : ℝ, 0 ≤ B → B ≤ DecisiveAstarFromFailure threshold

/-- Corollary threshold-unbounded theorem from decisive incompatibility route. -/
theorem decisiveSpine_Astar_infinite
    (threshold : DecisiveThresholdData)
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypotheses U t0)
    (upper_hypotheses : DecisiveSpineUpperHypotheses U t0) :
    DecisiveSpineAstarInfinite threshold := by
  intro B hB
  exact False.elim (decisiveSpine_incompatibility_theorem lower_hypotheses upper_hypotheses)

/-- Incompatibility-layer policy marker for decisive spine. -/
def DecisiveSpineIncompatibilityPolicy : Prop :=
  ∀ {U : VelocityTrajectory .torus3}
    {t0 : ℝ},
      DecisiveSpineLowerHypotheses U t0 →
        DecisiveSpineUpperHypotheses U t0 →
          False

/-- Dyadic incompatibility-layer policy marker for decisive spine. -/
def DecisiveSpineIncompatibilityPolicyDyadic : Prop :=
  ∀ {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ},
      DecisiveSpineLowerHypothesesDyadic F U t0 →
        DecisiveSpineUpperHypothesesDyadic F U t0 →
          False

/-- Incompatibility policy theorem for decisive spine. -/
theorem decisiveSpine_incompatibility_policy :
    DecisiveSpineIncompatibilityPolicy := by
  intro U t0 hLower hUpper
  exact decisiveSpine_incompatibility_theorem hLower hUpper

/-- Dyadic incompatibility policy theorem for decisive spine. -/
theorem decisiveSpine_incompatibility_policy_dyadic :
    DecisiveSpineIncompatibilityPolicyDyadic := by
  intro F U t0 hLower hUpper
  exact decisiveSpine_incompatibility_theorem_dyadic hLower hUpper

end StatMech.ContinuumField.NavierStokes
