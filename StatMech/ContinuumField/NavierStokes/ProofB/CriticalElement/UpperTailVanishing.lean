import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.LowerFluxBound

/-! # Hard-step upper-tail vanishing

Vanishing results for high-frequency flux tails and integrated defect terms from
dissipation plus envelope control.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Sequential `n → ∞` vanishing predicate on real sequences. -/
def TendsToZeroNat (a : Nat → ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N0 : Nat, ∀ N ≥ N0, |a N| ≤ ε

/-- Dissipation/envelope witness yielding tail decay controls. -/
structure TailVanishingWitness
    (E : DefectEnvelope .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) where
  dissipation_control : Prop
  envelope_control : IsGloballyBoundedEnvelope E
  tailBound : Nat → ℝ
  tailBound_nonneg : ∀ N, 0 ≤ tailBound N
  flux_bound : ∀ N, |scaleFlux N t0 U| ≤ tailBound N
  tail_tends_zero : TendsToZeroNat tailBound
  integratedDefect : Nat → ℝ
  integratedDefect_bound : ∀ N, |integratedDefect N| ≤ tailBound N

/-- Dyadic-form dissipation/envelope witness yielding tail decay controls. -/
structure TailVanishingWitnessDyadic
    (F : DyadicErasureFamily .torus3)
    (E : DefectEnvelope .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) where
  dissipation_control : Prop
  envelope_control : IsGloballyBoundedEnvelope E
  tailBound : Nat → ℝ
  tailBound_nonneg : ∀ N, 0 ≤ tailBound N
  flux_bound : ∀ N, |scaleFluxDyadic F N t0 U| ≤ tailBound N
  tail_tends_zero : TendsToZeroNat tailBound
  integratedDefect : Nat → ℝ
  integratedDefect_bound : ∀ N, |integratedDefect N| ≤ tailBound N

/-- Bridge: legacy tail-vanishing witness is a dyadic witness for the legacy
identity dyadic family used by `scaleFlux`. -/
def tailVanishingWitnessDyadic_of_legacy
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (W : TailVanishingWitness E U t0) :
    TailVanishingWitnessDyadic periodicCanonicalDyadicErasureFamily E U t0 := by
  refine
    { dissipation_control := W.dissipation_control
      envelope_control := W.envelope_control
      tailBound := W.tailBound
      tailBound_nonneg := W.tailBound_nonneg
      flux_bound := ?_
      tail_tends_zero := W.tail_tends_zero
      integratedDefect := W.integratedDefect
      integratedDefect_bound := W.integratedDefect_bound }
  intro N
  simpa [scaleFlux, scaleFluxDyadic, periodicDyadicDefectObservable,
    periodicDyadicDefectAtScale] using W.flux_bound N

/-- High-frequency flux tails vanish as `N → ∞`. -/
theorem scaleFlux_tail_vanishes
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (W : TailVanishingWitness E U t0) :
    TendsToZeroNat (fun N => scaleFlux N t0 U) := by
  intro ε hε
  rcases W.tail_tends_zero ε hε with ⟨N0, hN0⟩
  refine ⟨N0, ?_⟩
  intro N hN
  have htail : W.tailBound N ≤ ε := by
    simpa [abs_of_nonneg (W.tailBound_nonneg N)] using hN0 N hN
  exact le_trans (W.flux_bound N) htail

/-- Dyadic high-frequency flux tails vanish as `N → ∞`. -/
theorem scaleFluxDyadic_tail_vanishes
    {F : DyadicErasureFamily .torus3}
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (W : TailVanishingWitnessDyadic F E U t0) :
    TendsToZeroNat (fun N => scaleFluxDyadic F N t0 U) := by
  intro ε hε
  rcases W.tail_tends_zero ε hε with ⟨N0, hN0⟩
  refine ⟨N0, ?_⟩
  intro N hN
  have htail : W.tailBound N ≤ ε := by
    simpa [abs_of_nonneg (W.tailBound_nonneg N)] using hN0 N hN
  exact le_trans (W.flux_bound N) htail

/-- Integrated defect contribution vanishes as `N → ∞`. -/
theorem integratedDefect_tail_vanishes
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (W : TailVanishingWitness E U t0) :
    TendsToZeroNat W.integratedDefect := by
  intro ε hε
  rcases W.tail_tends_zero ε hε with ⟨N0, hN0⟩
  refine ⟨N0, ?_⟩
  intro N hN
  have htail : W.tailBound N ≤ ε := by
    simpa [abs_of_nonneg (W.tailBound_nonneg N)] using hN0 N hN
  exact le_trans (W.integratedDefect_bound N) htail

/-- Integrated defect contribution vanishes in the dyadic witness form. -/
theorem integratedDefect_tail_vanishes_dyadic
    {F : DyadicErasureFamily .torus3}
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (W : TailVanishingWitnessDyadic F E U t0) :
    TendsToZeroNat W.integratedDefect := by
  intro ε hε
  rcases W.tail_tends_zero ε hε with ⟨N0, hN0⟩
  refine ⟨N0, ?_⟩
  intro N hN
  have htail : W.tailBound N ≤ ε := by
    simpa [abs_of_nonneg (W.tailBound_nonneg N)] using hN0 N hN
  exact le_trans (W.integratedDefect_bound N) htail

end StatMech.ContinuumField.NavierStokes
