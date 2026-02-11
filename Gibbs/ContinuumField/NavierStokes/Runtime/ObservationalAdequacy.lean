import Gibbs.ContinuumField.NavierStokes.Runtime.CertifiedApproximation

/-!
# Observational adequacy hooks

Interfaces that connect Navier certificates to Telltale-style theorem-pack
runtime observations.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Observation stream model from runtime/theorem-pack infrastructure. -/
structure ObservationStream where
  /-- Time-indexed scalar summaries (e.g. norms, fluxes, residuals). -/
  sample : ℝ → ℝ

/-- Observational adequacy contract for certified approximations. -/
structure ObservationalAdequacyHook {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (A : CertifiedApproximation NS) where
  /-- Stream exported to runtime observation layer. -/
  stream : ObservationStream
  /-- Adequacy contract: observed quantity is controlled by certified envelope. -/
  adequate : ∀ t, |stream.sample t| ≤ A.errorEnvelope t

/-- Adequacy gives an immediate absolute-value bound from the certificate. -/
theorem observational_adequacy_bound {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    {A : CertifiedApproximation NS}
    (H : ObservationalAdequacyHook A) (t : ℝ) :
    |H.stream.sample t| ≤ certifiedErrorAt A t := by
  simpa [certifiedErrorAt] using H.adequate t

end Gibbs.ContinuumField.NavierStokes
