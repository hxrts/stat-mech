import Gibbs.ContinuumField.NavierStokes.Domain
import Mathlib.Topology.Basic

/-! # Navier-Stokes equation layer

Equation-level objects for incompressible 3D Navier-Stokes on a chosen domain.
This layer keeps operators abstract while making the equation predicates explicit.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Scalar field over a 3D spatial domain. -/
abbrev ScalarField (D : SpatialDomain3) : Type := SpatialCarrier D → ℝ

/-- Velocity field over a 3D spatial domain. -/
abbrev VelocityField (D : SpatialDomain3) : Type := SpatialCarrier D → Coord3

/-- Pressure field over a 3D spatial domain. -/
abbrev PressureField (D : SpatialDomain3) : Type := ScalarField D

/-- Time-dependent field family. -/
abbrev TimeDependent (α : Type) : Type := ℝ → α

/-- Velocity trajectory over time. -/
abbrev VelocityTrajectory (D : SpatialDomain3) : Type := TimeDependent (VelocityField D)

/-- Pressure trajectory over time. -/
abbrev PressureTrajectory (D : SpatialDomain3) : Type := TimeDependent (PressureField D)

/-- Differential operators used by the incompressible Navier-Stokes system. -/
structure DifferentialOps (D : SpatialDomain3) where
  /-- Pressure gradient operator. -/
  grad : PressureField D → VelocityField D
  /-- Divergence operator. -/
  div : VelocityField D → ScalarField D
  /-- Vector Laplacian. -/
  laplace : VelocityField D → VelocityField D
  /-- Convective term `(u · ∇)u` represented as an operator in `u`. -/
  convection : VelocityField D → VelocityField D

/-- Incompressible Navier-Stokes physical/analytic parameters. -/
structure IncompressibleNavierStokes (D : SpatialDomain3) where
  /-- Differential operators for the chosen domain/model. -/
  ops : DifferentialOps D
  /-- Kinematic viscosity coefficient `ν`. -/
  nu : ℝ
  /-- Positive viscosity condition. -/
  nu_pos : 0 < nu
  /-- External forcing field. -/
  forcing : VelocityField D

/-- Concrete smoothness proxy for velocity fields used throughout the NSE route. -/
def ConcreteSmoothVelocity {D : SpatialDomain3} (u : VelocityField D) : Prop :=
  Continuous u

/-- Concrete smoothness proxy for pressure fields used throughout the NSE route. -/
def ConcreteSmoothPressure {D : SpatialDomain3} (p : PressureField D) : Prop :=
  Continuous p

/-- Velocity regularity predicate determined by the NS model. -/
def IsSmoothField {D : SpatialDomain3} (_NS : IncompressibleNavierStokes D)
    (u : VelocityField D) : Prop :=
  ConcreteSmoothVelocity u

/-- Pressure regularity predicate determined by the NS model. -/
def IsSmoothPressure {D : SpatialDomain3} (_NS : IncompressibleNavierStokes D)
    (p : PressureField D) : Prop :=
  ConcreteSmoothPressure p

/-- Divergence-free predicate for an arbitrary divergence operator. -/
def IsDivergenceFreeWith {D : SpatialDomain3}
    (div : VelocityField D → ScalarField D) (u : VelocityField D) : Prop :=
  div u = 0

/-- Divergence-free predicate under the NS model's divergence operator. -/
def IsDivergenceFree {D : SpatialDomain3} (NS : IncompressibleNavierStokes D)
    (u : VelocityField D) : Prop :=
  IsDivergenceFreeWith NS.ops.div u

/-- Momentum residual `∂t u + (u·∇)u + ∇p - νΔu - f`. -/
def MomentumResidual {D : SpatialDomain3} (NS : IncompressibleNavierStokes D)
    (u : VelocityField D) (p : PressureField D) (du_dt : VelocityField D) : VelocityField D :=
  du_dt + NS.ops.convection u + NS.ops.grad p - NS.nu • NS.ops.laplace u - NS.forcing

/-- Incompressibility residual `div u`. -/
def IncompressibilityResidual {D : SpatialDomain3} (NS : IncompressibleNavierStokes D)
    (u : VelocityField D) : ScalarField D :=
  NS.ops.div u

/-- Predicate that the momentum equation holds exactly. -/
def SatisfiesMomentumEq {D : SpatialDomain3} (NS : IncompressibleNavierStokes D)
    (u : VelocityField D) (p : PressureField D) (du_dt : VelocityField D) : Prop :=
  MomentumResidual NS u p du_dt = 0

/-- Predicate that the incompressibility equation holds exactly. -/
def SatisfiesIncompressibility {D : SpatialDomain3} (NS : IncompressibleNavierStokes D)
    (u : VelocityField D) : Prop :=
  IncompressibilityResidual NS u = 0

/-- Predicate asserting that `(u,p)` solves incompressible Navier-Stokes. -/
def SolvesNavierStokes {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (u : VelocityField D) (p : PressureField D) (du_dt : VelocityField D) : Prop :=
  SatisfiesMomentumEq NS u p du_dt ∧ SatisfiesIncompressibility NS u

/-- Unfolding theorem for the full Navier-Stokes predicate. -/
theorem solvesNavierStokes_iff {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (u : VelocityField D) (p : PressureField D) (du_dt : VelocityField D) :
    SolvesNavierStokes NS u p du_dt ↔
      MomentumResidual NS u p du_dt = 0 ∧ IncompressibilityResidual NS u = 0 := by
  rfl

end Gibbs.ContinuumField.NavierStokes
