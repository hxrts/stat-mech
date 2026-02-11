import Gibbs.ContinuumField.NavierStokes.Core

/-!
# Navier-Stokes domain setup

Foundational domain-level declarations for the 3D incompressible
Navier-Stokes program.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical spatial domains used by the Navier-Stokes program. -/
inductive SpatialDomain3 where
  | torus3
  | euclidean3
  deriving Inhabited, Repr, DecidableEq

/-- Coordinate model for three-dimensional vectors. -/
abbrev Coord3 := Fin 3 → ℝ

/-- Spatial carrier associated with the chosen 3D domain. -/
abbrev SpatialCarrier (_D : SpatialDomain3) : Type := Coord3

/-- Initial-velocity package for the 3D incompressible problem. -/
structure InitialVelocityField (D : SpatialDomain3) where
  /-- Initial velocity vector field u0. -/
  u0 : SpatialCarrier D → Coord3
  /-- Divergence-free side condition. -/
  divergenceFree : Prop
  /-- Smoothness side condition. -/
  smooth : Prop
  /-- Finite-energy side condition. -/
  finiteEnergy : Prop

/-- Program default domain for first formalization pass. -/
abbrev DefaultDomain : SpatialDomain3 := .torus3

end Gibbs.ContinuumField.NavierStokes
