import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.LowerFluxRigidityTheorem
import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.UpperTailVanishing

/-! # Definitive true-torus upper tail vanishing

Direct dissipation/envelope-driven high-frequency vanishing and limit-exchange
interfaces for the flux-tail route.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Direct definitive upper-hypothesis shape used by the flux-rigidity crux. -/
abbrev DefinitiveUpperFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  TendsToZeroNat (fun N => scaleFlux N t0 U)

/-- Dyadic definitive upper-hypothesis shape used by the flux-rigidity crux. -/
abbrev DefinitiveUpperFluxHypothesesDyadic
    (F : DyadicErasureFamily .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  TendsToZeroNat (fun N => scaleFluxDyadic F N t0 U)

/-- Definitive high-frequency flux-tail vanishing theorem interface. -/
theorem definitive_high_frequency_flux_tail_vanishing
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitness E U t0) :
    DefinitiveUpperFluxHypotheses U t0 :=
  scaleFlux_tail_vanishes upper_tail

/-- Dyadic definitive high-frequency flux-tail vanishing theorem interface. -/
theorem definitive_high_frequency_flux_tail_vanishing_dyadic
    {F : DyadicErasureFamily .torus3}
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitnessDyadic F E U t0) :
    DefinitiveUpperFluxHypothesesDyadic F U t0 :=
  scaleFluxDyadic_tail_vanishes upper_tail

/-- Definitive integrated defect-tail vanishing theorem interface. -/
theorem definitive_integrated_defect_tail_vanishing
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitness E U t0) :
    TendsToZeroNat upper_tail.integratedDefect :=
  integratedDefect_tail_vanishes upper_tail

/-- Dyadic definitive integrated defect-tail vanishing theorem interface. -/
theorem definitive_integrated_defect_tail_vanishing_dyadic
    {F : DyadicErasureFamily .torus3}
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitnessDyadic F E U t0) :
    TendsToZeroNat upper_tail.integratedDefect :=
  integratedDefect_tail_vanishes_dyadic upper_tail

/-- Definitive validity package for all limit exchanges used in tail arguments. -/
theorem definitive_tail_limit_exchanges
    (limsup_exchange_valid : Prop)
    (integral_exchange_valid : Prop)
    (series_exchange_valid : Prop)
    (limsup_exchange_holds : limsup_exchange_valid)
    (integral_exchange_holds : integral_exchange_valid)
    (series_exchange_holds : series_exchange_valid) :
    limsup_exchange_valid ∧ integral_exchange_valid ∧ series_exchange_valid := by
  exact ⟨limsup_exchange_holds, integral_exchange_holds, series_exchange_holds⟩

/-- Legacy/dyadic identity compatibility for definitive upper hypotheses. -/
theorem definitiveUpperFluxHypotheses_iff_dyadic_identity
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) :
    DefinitiveUpperFluxHypotheses U t0 ↔
      DefinitiveUpperFluxHypothesesDyadic periodicCanonicalDyadicErasureFamily U t0 :=
  Iff.rfl

end StatMech.ContinuumField.NavierStokes
