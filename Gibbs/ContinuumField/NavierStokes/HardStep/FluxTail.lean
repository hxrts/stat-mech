import Gibbs.ContinuumField.NavierStokes.HardStep.MinimalElement
import Gibbs.ContinuumField.NavierStokes.Erasure.ConcretePeriodic

/-! # Hard-step flux and tail dynamics

Exact scale-flux functionals and high-frequency tail identities used by the
hard-step contradiction route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical
noncomputable section

/-- Scale flux `Π_N(t)` at spatial origin in the periodic model. -/
def scaleFlux
    (N : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) : ℝ :=
  periodicEnergyFluxAtScale N (U t) originCoord3

/-- Cumulative high-frequency tail over a finite dyadic window (recursive form). -/
def cumulativeHighFrequencyTail
    (N : Nat)
    (K : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) : ℝ :=
  Nat.rec (motive := fun _ => ℝ) (|scaleFlux N t U|)
    (fun k acc => acc + |scaleFlux (N + k + 1) t U|) K

/-- Exact flux-balance data linking flux, dissipation, and defect-envelope terms. -/
structure FluxBalanceIdentityData
    (E : DefectEnvelope .torus3)
    (U : VelocityTrajectory .torus3) where
  dissipationTerm : Nat → ℝ → ℝ
  defectTerm : Nat → ℝ → ℝ
  exact_balance :
    ∀ N t, scaleFlux N t U = dissipationTerm N t + defectTerm N t + E.defectNorm t

/-- Exact balance identity theorem for the scale flux `Π_N(t)`. -/
theorem scaleFlux_exact_balance
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    (B : FluxBalanceIdentityData E U) :
    ∀ N t, scaleFlux N t U = B.dissipationTerm N t + B.defectTerm N t + E.defectNorm t :=
  B.exact_balance

/-- Monotonicity in window length for cumulative high-frequency tails. -/
theorem cumulativeHighFrequencyTail_monotone
    (N K : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) :
    cumulativeHighFrequencyTail N K t U ≤ cumulativeHighFrequencyTail N (K + 1) t U := by
  induction K with
  | zero =>
      simp [cumulativeHighFrequencyTail]
  | succ k ih =>
      simp [cumulativeHighFrequencyTail, Nat.add_assoc, Nat.add_left_comm, Nat.add_comm]

/-- Witness package for tail-window concatenation identities. -/
structure TailConcatWitness (U : VelocityTrajectory .torus3) where
  concat :
    ∀ N K₁ K₂ t,
      cumulativeHighFrequencyTail N (K₁ + K₂ + 1) t U =
        cumulativeHighFrequencyTail N K₁ t U
          + cumulativeHighFrequencyTail (N + K₁ + 1) K₂ t U

/-- Window concatenation identity for cumulative high-frequency tails. -/
theorem cumulativeHighFrequencyTail_concat
    (U : VelocityTrajectory .torus3)
    (W : TailConcatWitness U) :
    ∀ N K₁ K₂ t,
      cumulativeHighFrequencyTail N (K₁ + K₂ + 1) t U =
        cumulativeHighFrequencyTail N K₁ t U
          + cumulativeHighFrequencyTail (N + K₁ + 1) K₂ t U :=
  W.concat

/-- Subadditivity-form inequality obtained from tail concatenation. -/
theorem cumulativeHighFrequencyTail_subadditive
    (U : VelocityTrajectory .torus3)
    (W : TailConcatWitness U) :
    ∀ N K₁ K₂ t,
      cumulativeHighFrequencyTail N (K₁ + K₂ + 1) t U ≤
        cumulativeHighFrequencyTail N K₁ t U
          + cumulativeHighFrequencyTail (N + K₁ + 1) K₂ t U := by
  intro N K₁ K₂ t
  exact le_of_eq (W.concat N K₁ K₂ t)

end

end Gibbs.ContinuumField.NavierStokes
