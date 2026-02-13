import Gibbs.ContinuumField.NavierStokes.Geometry.TorusModel
import Mathlib.Topology.Basic

/-! # True torus field layer

Smooth periodic scalar/vector field interfaces on the true torus carrier
`(ℝ/ℤ)^3`.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Scalar fields on the true torus carrier. -/
abbrev TrueTorusScalarField : Type := TorusPoint3 → ℝ

/-- Vector fields on the true torus carrier. -/
abbrev TrueTorusVectorField : Type := TorusPoint3 → Coord3

/-- Smoothness predicate for true-torus scalar fields. -/
def IsSmoothTrueTorusScalarField (f : TrueTorusScalarField) : Prop :=
  Continuous f

/-- Smoothness predicate for true-torus vector fields. -/
def IsSmoothTrueTorusVectorField (u : TrueTorusVectorField) : Prop :=
  Continuous u

/-- Smooth periodic scalar-field package on `(ℝ/ℤ)^3`. -/
structure SmoothPeriodicScalarField where
  field : TrueTorusScalarField
  smooth : IsSmoothTrueTorusScalarField field

/-- Smooth periodic vector-field package on `(ℝ/ℤ)^3`. -/
structure SmoothPeriodicVectorField where
  field : TrueTorusVectorField
  smooth : IsSmoothTrueTorusVectorField field

/-- Pointwise sum on true-torus scalar fields. -/
def trueTorusScalarAdd (f g : TrueTorusScalarField) : TrueTorusScalarField :=
  fun x => f x + g x

/-- Pointwise product on true-torus scalar fields. -/
def trueTorusScalarMul (f g : TrueTorusScalarField) : TrueTorusScalarField :=
  fun x => f x * g x

/-- Pointwise sum on true-torus vector fields. -/
def trueTorusVectorAdd (u v : TrueTorusVectorField) : TrueTorusVectorField :=
  fun x => u x + v x

/-- Pointwise dot product on true-torus vector fields. -/
def trueTorusDot (u v : TrueTorusVectorField) : TrueTorusScalarField :=
  fun x => (u x 0) * (v x 0) + (u x 1) * (v x 1) + (u x 2) * (v x 2)

end Gibbs.ContinuumField.NavierStokes
