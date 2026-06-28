import StatMech.ContinuumField.NavierStokes.Equation

/-! # Erasure operators

Exact coarse-graining operator interface for Navier-Stokes erasure analysis.
This is the legacy algebraic layer used across the hard-step cone; dyadic
conditional-expectation families refine this layer by adding `L2` and
refinement laws on top of the same projection-style primitives.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Admissible erasure/coarse-graining operator at a fixed scale. -/
structure ErasureOperator (D : SpatialDomain3) where
  /-- Operator action on velocity fields. -/
  map : VelocityField D → VelocityField D
  /-- Idempotence law (projection-style erasure). -/
  idempotent : ∀ u, map (map u) = map u
  /-- Preserves divergence-free constraints. -/
  preserves_divfree : (div : VelocityField D → ScalarField D) →
    ∀ u, IsDivergenceFreeWith div u → IsDivergenceFreeWith div (map u)

/-- Scale-indexed erasure family `E_N`.
In dyadic instantiations this corresponds to a scale projection chain. -/
structure ErasureFamily (D : SpatialDomain3) where
  /-- Erasure operator at level `N`. -/
  atScale : Nat → ErasureOperator D

/-- Residual (erased) component induced by the erasure operator. -/
def residualComponent {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) : VelocityField D :=
  u - E.map u

/-- Exact additive decomposition into resolved + residual components. -/
theorem resolved_plus_residual {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) :
    E.map u + residualComponent E u = u := by
  funext x
  simp [residualComponent]

/-- Erasure-induced decomposition theorem for each family scale `N`. -/
theorem family_resolved_plus_residual {D : SpatialDomain3}
    (F : ErasureFamily D) (N : Nat) (u : VelocityField D) :
    (F.atScale N).map u + residualComponent (F.atScale N) u = u :=
  resolved_plus_residual (F.atScale N) u

end StatMech.ContinuumField.NavierStokes
