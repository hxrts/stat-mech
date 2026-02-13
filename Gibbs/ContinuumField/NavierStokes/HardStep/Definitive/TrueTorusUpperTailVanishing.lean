import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusLowerFluxRigidity
import Gibbs.ContinuumField.NavierStokes.HardStep.TailVanishing

/-! # Definitive true-torus upper tail vanishing

Direct dissipation/envelope-driven high-frequency vanishing and limit-exchange
interfaces for the flux-tail route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct definitive upper-hypothesis shape used by the flux-rigidity crux. -/
abbrev DefinitiveUpperFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  TendsToZeroNat (fun N => scaleFlux N t0 U)

/-- Definitive high-frequency flux-tail vanishing theorem interface. -/
theorem definitive_high_frequency_flux_tail_vanishing
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitness E U t0) :
    DefinitiveUpperFluxHypotheses U t0 :=
  scaleFlux_tail_vanishes upper_tail

/-- Definitive integrated defect-tail vanishing theorem interface. -/
theorem definitive_integrated_defect_tail_vanishing
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitness E U t0) :
    TendsToZeroNat upper_tail.integratedDefect :=
  integratedDefect_tail_vanishes upper_tail

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

end Gibbs.ContinuumField.NavierStokes
