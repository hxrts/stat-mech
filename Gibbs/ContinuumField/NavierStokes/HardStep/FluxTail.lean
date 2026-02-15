import Gibbs.ContinuumField.NavierStokes.HardStep.MinimalElement
import Gibbs.ContinuumField.NavierStokes.Erasure.ConcretePeriodic
import Gibbs.ContinuumField.NavierStokes.Erasure.DyadicPeriodic

/-! # Hard-step flux and tail dynamics

Exact scale-flux functionals and high-frequency tail identities used by the
hard-step contradiction route.

Note: `scaleFlux` now routes through the canonical non-identity periodic dyadic
family (`periodicCanonicalDyadicErasureFamily`). General dyadic observables are
provided in `Erasure/DyadicObservable.lean`.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical scale flux `Π_N(t)` in the periodic model. -/
def scaleFlux
    (N : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) : ℝ :=
  periodicDyadicDefectObservable periodicCanonicalDyadicErasureFamily N (U t)

/-- Dyadic scale observable at scale `N` along trajectory `U(t)`. -/
def scaleFluxDyadic
    (F : DyadicErasureFamily .torus3)
    (N : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) : ℝ :=
  periodicDyadicDefectAtScale F N (U t)

/-- Canonical scale flux is exactly dyadic scale flux for the canonical family. -/
theorem scaleFlux_eq_scaleFluxDyadic_canonical
    (N : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) :
    scaleFlux N t U = scaleFluxDyadic periodicCanonicalDyadicErasureFamily N t U := by
  rfl

/-- Canonical nontrivial trajectory witness (constant in time). -/
def periodicUnitTrajectory : VelocityTrajectory .torus3 :=
  fun _ => periodicUnitField

/-- Nontriviality witness: canonical scale flux is strictly positive at one scale/time. -/
theorem scaleFlux_canonical_nontrivial :
    0 < scaleFlux 0 0 periodicUnitTrajectory := by
  simpa [scaleFlux, periodicUnitTrajectory] using periodicCanonicalDyadicDefect_positive

/-- Cumulative high-frequency tail over a finite dyadic window (legacy recursive form). -/
def cumulativeHighFrequencyTail
    (N : Nat)
    (K : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) : ℝ :=
  Nat.rec (motive := fun _ => ℝ) (|scaleFlux N t U|)
    (fun k acc => acc + |scaleFlux (N + k + 1) t U|) K

/-- Cumulative dyadic high-frequency tail over a finite window. -/
def cumulativeHighFrequencyTailDyadic
    (F : DyadicErasureFamily .torus3)
    (N : Nat)
    (K : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) : ℝ :=
  dyadicIncrementSum F N K (U t)

/-- Dyadic finite-window telescoping identity for cumulative tails. -/
theorem cumulativeHighFrequencyTailDyadic_telescoping
    (F : DyadicErasureFamily .torus3)
    (T : DyadicIncrementTheorems F)
    (N : Nat)
    (K : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) :
    cumulativeHighFrequencyTailDyadic F N K t U =
      dyadicResolvedEnergy F (N + K + 1) (U t) - dyadicResolvedEnergy F N (U t) := by
  simpa [cumulativeHighFrequencyTailDyadic] using
    dyadicIncrementSum_telescoping (T := T) N K (U t)

/-- Dyadic finite-window tail bounded by total `L2` energy at time `t`. -/
theorem cumulativeHighFrequencyTailDyadic_le_totalEnergy
    (F : DyadicErasureFamily .torus3)
    (T : DyadicIncrementTheorems F)
    (N : Nat)
    (K : Nat)
    (t : ℝ)
    (U : VelocityTrajectory .torus3) :
    cumulativeHighFrequencyTailDyadic F N K t U ≤ (F.l2Norm (U t)) ^ 2 := by
  simpa [cumulativeHighFrequencyTailDyadic] using
    dyadicIncrementSum_le_totalEnergy (T := T) N K (U t)

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

end Gibbs.ContinuumField.NavierStokes
