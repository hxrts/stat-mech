import Gibbs.ContinuumField.NavierStokes.Runtime.ObservationalAdequacy

/-!
# Bounded-time no-blowup certificates

Certified bounded-time no-blowup results from verified approximations and
explicit envelopes.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Verified bounded-time no-blowup certificate. -/
structure BoundedTimeNoBlowupCertificate {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D) where
  /-- Time horizon covered by the certificate. -/
  T : ℝ
  /-- Nonnegative time horizon. -/
  T_nonneg : 0 ≤ T
  /-- Critical norm used by the certificate. -/
  K : CriticalNorm D
  /-- Strong solution trajectory under certification. -/
  sol : StrongSolution NS
  /-- Explicit certified bound. -/
  bound : ℝ
  /-- Boundedness claim on `[0,T]`. -/
  no_blowup_on_horizon : ∀ t, 0 ≤ t → t ≤ T → K.value (sol.vel t) ≤ bound

/-- Any bounded-time certificate yields a `NoBlowupUpTo` statement. -/
theorem certificate_implies_no_blowup_up_to {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (C : BoundedTimeNoBlowupCertificate NS) :
    NoBlowupUpTo NS C.K C.sol C.T C.bound :=
  C.no_blowup_on_horizon

/-- Runtime theorem-pack adequacy + certified approximation can be packaged
as a bounded-time no-blowup interface result once a bound is supplied. -/
theorem runtime_certification_yields_no_blowup {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (_A : CertifiedApproximation NS)
    (_Hobs : ObservationalAdequacyHook _A)
    (C : BoundedTimeNoBlowupCertificate NS) :
    NoBlowupUpTo NS C.K C.sol C.T C.bound :=
  certificate_implies_no_blowup_up_to C

end Gibbs.ContinuumField.NavierStokes
