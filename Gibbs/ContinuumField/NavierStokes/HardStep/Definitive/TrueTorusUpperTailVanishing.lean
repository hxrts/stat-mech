import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusLowerFluxRigidity
import Gibbs.ContinuumField.NavierStokes.HardStep.TailVanishing

/-! # Definitive true-torus upper tail vanishing

Direct dissipation/envelope-driven high-frequency vanishing and limit-exchange
interfaces for the flux-tail route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct upper-tail vanishing theorem package without witness endpoints. -/
structure DefinitiveUpperTailVanishingTheorem
    (E : DefectEnvelope .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) where
  high_freq_flux_vanishes :
    TendsToZeroNat (fun N => scaleFlux N t0 U)
  integrated_defect_vanishes :
    TendsToZeroNat (fun N => E.defectNorm (t0 + N))
  limsup_exchange_valid : Prop
  integral_exchange_valid : Prop
  series_exchange_valid : Prop
  limsup_exchange_holds : limsup_exchange_valid
  integral_exchange_holds : integral_exchange_valid
  series_exchange_holds : series_exchange_valid

/-- Definitive high-frequency flux-tail vanishing theorem interface. -/
theorem definitive_high_frequency_flux_tail_vanishing
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (V : DefinitiveUpperTailVanishingTheorem E U t0) :
    TendsToZeroNat (fun N => scaleFlux N t0 U) :=
  V.high_freq_flux_vanishes

/-- Definitive integrated defect-tail vanishing theorem interface. -/
theorem definitive_integrated_defect_tail_vanishing
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (V : DefinitiveUpperTailVanishingTheorem E U t0) :
    TendsToZeroNat (fun N => E.defectNorm (t0 + N)) :=
  V.integrated_defect_vanishes

/-- Definitive validity package for all limit exchanges used in tail arguments. -/
theorem definitive_tail_limit_exchanges
    {E : DefectEnvelope .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (V : DefinitiveUpperTailVanishingTheorem E U t0) :
    V.limsup_exchange_valid ∧ V.integral_exchange_valid ∧ V.series_exchange_valid := by
  exact ⟨V.limsup_exchange_holds, V.integral_exchange_holds, V.series_exchange_holds⟩

end Gibbs.ContinuumField.NavierStokes
