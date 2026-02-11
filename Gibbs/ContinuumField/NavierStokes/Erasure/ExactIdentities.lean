import Gibbs.ContinuumField.NavierStokes.Erasure.Operators

/-!
# Exact erasure identities

Exact algebraic identities for coarse/residual decomposition and defect terms.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Resolved velocity at scale defined by erasure operator `E`. -/
def coarseVelocity {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) : VelocityField D :=
  E.map u

/-- Residual velocity at scale defined by erasure operator `E`. -/
def residualVelocity {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) : VelocityField D :=
  residualComponent E u

/-- Defect term induced by applying erasure twice. -/
def defectTerm {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) : VelocityField D :=
  E.map u - E.map (E.map u)

/-- Exact decomposition identity: u = coarse + residual. -/
theorem exact_decomposition {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) :
    u = coarseVelocity E u + residualVelocity E u := by
  simpa [coarseVelocity, residualVelocity, add_comm] using
    (resolved_plus_residual E u).symm

/-- Idempotent erasure implies zero defect term exactly. -/
theorem defect_zero_of_idempotent {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) : defectTerm E u = 0 := by
  funext x
  simp [defectTerm, E.idempotent]

end Gibbs.ContinuumField.NavierStokes
