import Gibbs.ContinuumField.NavierStokes.SolutionNotions

/-!
# Erasure operators

Exact coarse-graining operator interface for Navier-Stokes erasure analysis.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Admissible erasure/coarse-graining operator family at scale N. -/
structure ErasureOperator (D : SpatialDomain3) where
  /-- Operator action on velocity fields. -/
  map : VelocityField D → VelocityField D
  /-- Idempotence law (projection-style erasure). -/
  idempotent : ∀ u, map (map u) = map u
  /-- Preserves divergence-free constraints. -/
  preserves_divfree : ∀ u, IsDivergenceFree u → IsDivergenceFree (map u)

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

end Gibbs.ContinuumField.NavierStokes
