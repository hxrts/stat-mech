import Gibbs.ContinuumField.NavierStokes.Erasure.ExactIdentities

/-! # Energy/flux identities

Pointwise energy and defect-flux bookkeeping for exact erasure analyses.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

noncomputable section

/-- Pointwise kinetic energy density (up to 1/2 factor). -/
def pointEnergy {D : SpatialDomain3} (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  (1 / 2 : ℝ) * ((u x 0) ^ 2 + (u x 1) ^ 2 + (u x 2) ^ 2)

/-- Resolved energy density induced by an erasure operator. -/
def resolvedEnergy {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  pointEnergy (coarseVelocity E u) x

/-- Residual energy density induced by an erasure operator. -/
def residualEnergy {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  pointEnergy (residualVelocity E u) x

/-- Defect-flux placeholder capturing unresolved-scale transfer. -/
def defectFlux {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  pointEnergy u x - resolvedEnergy E u x

/-- Exact pointwise split of total energy into resolved energy + defect flux. -/
theorem exact_energy_flux_split {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) :
    pointEnergy u x = resolvedEnergy E u x + defectFlux E u x := by
  simp [defectFlux, resolvedEnergy]

end

end Gibbs.ContinuumField.NavierStokes
