import Gibbs.ContinuumField.NavierStokes.HardStep.TailVanishing

/-! # Hard-step contradiction and closure

Final contradiction theorem combining lower-bound rigidity with upper-tail
vanishing, and global-closure corollaries.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct lower-flux hypothesis shape for the hard-step contradiction crux. -/
abbrev HardStepLowerFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  ∃ η > (0 : ℝ), ∃ N0 : Nat,
    ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|

/-- Direct upper-flux hypothesis shape for the hard-step contradiction crux. -/
abbrev HardStepUpperFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  TendsToZeroNat (fun N => scaleFlux N t0 U)

/-- Quantitative incompatibility lemma: persistent positive lower bound cannot vanish. -/
theorem hardStep_quantitative_flux_incompatibility
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    {η : ℝ}
    {N0 : Nat}
    (hη_pos : η > 0)
    (hLower : ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|)
    (hUpper : TendsToZeroNat (fun N => scaleFlux N t0 U)) :
    False := by
  have htwo_pos : 0 < (2 : ℝ) := by norm_num
  have hhalf_pos : 0 < η / 2 := div_pos hη_pos htwo_pos
  rcases hUpper (η / 2) hhalf_pos with ⟨N1, hN1⟩
  let N : Nat := max N0 N1
  have hlow : η ≤ |scaleFlux N t0 U| := hLower N (le_max_left _ _)
  have hhigh : |scaleFlux N t0 U| ≤ η / 2 :=
    hN1 N (le_max_right _ _)
  have hη_half : η ≤ η / 2 := le_trans hlow hhigh
  exact (not_le_of_gt (half_lt_self hη_pos)) hη_half

/-- Core hard-step contradiction: direct lower flux bound vs direct vanishing tail. -/
theorem hardStep_flux_barrier_contradiction
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : HardStepLowerFluxHypotheses U t0)
    (upper_hypotheses : HardStepUpperFluxHypotheses U t0) :
    False := by
  rcases lower_hypotheses with ⟨η, hη_pos, N0, hLower⟩
  exact hardStep_quantitative_flux_incompatibility hη_pos hLower upper_hypotheses

/-- Hard-step global-closure statement: no minimal element can survive the flux barrier. -/
def HardStepGlobalClosure : Prop :=
  ∀ _m : HardStepMinimalElement, False

/-- Global closure corollary from direct per-minimal lower/upper hypothesis families. -/
theorem hardStep_global_closure_of_flux_hypotheses
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (t0_of : HardStepMinimalElement → ℝ)
    (lower_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        HardStepLowerFluxHypotheses (trajectoryOf m) (t0_of m))
    (upper_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        HardStepUpperFluxHypotheses (trajectoryOf m) (t0_of m)) :
    HardStepGlobalClosure := by
  intro m
  exact hardStep_flux_barrier_contradiction
    (lower_hypotheses_of m)
    (upper_hypotheses_of m)

end Gibbs.ContinuumField.NavierStokes
