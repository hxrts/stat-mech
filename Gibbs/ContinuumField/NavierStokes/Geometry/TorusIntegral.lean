import Gibbs.ContinuumField.NavierStokes.Geometry.TorusCalculus

/-! # True torus integration identities

Integration-by-parts and divergence-zero interfaces specialized to the
boundaryless periodic geometry `(ℝ/ℤ)^3`.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Torus scalar integration functional. -/
structure TorusScalarIntegral where
  integral : TrueTorusScalarField → ℝ

/-- Gradient-divergence pairing integrand `∇φ · u`. -/
def torusGradDotField
    (C : TorusClassicalDerivativeOps)
    (φ : TrueTorusScalarField)
    (u : TrueTorusVectorField) : TrueTorusScalarField :=
  trueTorusDot (C.grad φ) u

/-- Product field `φ * div u`. -/
def torusPhiDivField
    (C : TorusClassicalDerivativeOps)
    (φ : TrueTorusScalarField)
    (u : TrueTorusVectorField) : TrueTorusScalarField :=
  trueTorusScalarMul φ (C.div u)

/-- Integration identities package on the true torus. -/
structure TorusIntegralIdentityPackage
    (C : TorusClassicalDerivativeOps)
    (I : TorusScalarIntegral) where
  /-- First-order integration by parts on boundaryless torus. -/
  integration_by_parts :
    ∀ φ u,
      I.integral (torusGradDotField C φ u) =
        - I.integral (torusPhiDivField C φ u)
  /-- Divergence theorem specialization: boundary contribution is zero. -/
  divergence_zero :
    ∀ u, I.integral (C.div u) = 0

/-- Integration-by-parts theorem on `T^3 = (ℝ/ℤ)^3`. -/
theorem torus_integration_by_parts
    (C : TorusClassicalDerivativeOps)
    (I : TorusScalarIntegral)
    (P : TorusIntegralIdentityPackage C I) :
    ∀ φ u,
      I.integral (torusGradDotField C φ u) =
        - I.integral (torusPhiDivField C φ u) :=
  P.integration_by_parts

/-- Divergence theorem on the periodic torus: integral of divergence is zero. -/
theorem torus_divergence_theorem
    (C : TorusClassicalDerivativeOps)
    (I : TorusScalarIntegral)
    (P : TorusIntegralIdentityPackage C I) :
    ∀ u, I.integral (C.div u) = 0 :=
  P.divergence_zero

/-- Zero-boundary-term corollary for periodic geometry. -/
theorem torus_zero_boundary_term
    (C : TorusClassicalDerivativeOps)
    (I : TorusScalarIntegral)
    (P : TorusIntegralIdentityPackage C I)
    (u : TrueTorusVectorField) :
    I.integral (C.div u) = 0 :=
  P.divergence_zero u

end Gibbs.ContinuumField.NavierStokes
