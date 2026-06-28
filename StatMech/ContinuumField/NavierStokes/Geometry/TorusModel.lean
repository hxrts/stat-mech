import StatMech.ContinuumField.NavierStokes.Domain

/-! # True torus model primitives

Computable proxy carrier definitions for the true-torus interface used by the
periodic Navier-Stokes development.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- One torus-axis coordinate in the computable proxy model. -/
abbrev TorusAxis : Type := ℝ

/-- Three-dimensional torus proxy point (coordinate form). -/
abbrev TorusPoint3 : Type := Coord3

/-- Canonical map from Euclidean coordinates to torus-proxy coordinates. -/
def coordToTorusPoint3 (x : Coord3) : TorusPoint3 :=
  x

/-- Componentwise addition on torus-proxy points. -/
def torusPointAdd (x y : TorusPoint3) : TorusPoint3 :=
  fun i => x i + y i

/-- Canonical integer-lattice shift represented in torus-proxy coordinates. -/
def torusIntegerShift (n : Fin 3 → ℤ) : TorusPoint3 :=
  fun i => (n i : ℝ)

/-- Additive action of an integer-lattice shift on a torus-proxy point. -/
def torusShiftByInteger (x : TorusPoint3) (n : Fin 3 → ℤ) : TorusPoint3 :=
  torusPointAdd x (torusIntegerShift n)

/-- Placeholder bridge predicate for migrating torus-domain fields to the true carrier. -/
def UsesTrueTorusCarrier (α : Type) : Prop :=
  α = TorusPoint3

end StatMech.ContinuumField.NavierStokes
