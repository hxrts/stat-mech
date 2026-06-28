import StatMech.ContinuumField.NavierStokes.Erasure.ExactIdentities
import StatMech.ContinuumField.NavierStokes.Erasure.DyadicObservable

/-! # Energy/flux identities

Legacy pointwise energy and defect-flux bookkeeping for exact erasure analyses.
Canonical decisive observables for current hard-step migration live in the dyadic
`L2` layer (`Erasure/DyadicObservable.lean`).
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Pointwise kinetic energy density (up to 1/2 factor). -/
def pointEnergy {D : SpatialDomain3} (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  ((1 / 2 : ℚ) : ℝ) * ((u x 0) ^ 2 + (u x 1) ^ 2 + (u x 2) ^ 2)

/-- Resolved energy density induced by an erasure operator. -/
def resolvedEnergy {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  pointEnergy (coarseVelocity E u) x

/-- Residual energy density induced by an erasure operator. -/
def residualEnergy {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  pointEnergy (residualVelocity E u) x

/-- Legacy defect-flux placeholder capturing unresolved-scale transfer. -/
def defectFlux {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) : ℝ :=
  pointEnergy u x - resolvedEnergy E u x

/-- Exact pointwise split of total energy into resolved energy + defect flux. -/
theorem exact_energy_flux_split {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) (x : SpatialCarrier D) :
    pointEnergy u x = resolvedEnergy E u x + defectFlux E u x := by
  simp [defectFlux, resolvedEnergy]

/-- Compatibility bridge: if pointwise and dyadic energy notions are aligned at scale `N`,
then legacy pointwise defect flux equals the dyadic global observable at that scale. -/
theorem defectFlux_eq_dyadicObservable_of_energy_alignment {D : SpatialDomain3}
    (E : ErasureOperator D)
    (F : DyadicErasureFamily D)
    (N : Nat)
    (u : VelocityField D)
    (x : SpatialCarrier D)
    (hTotalAlign : pointEnergy u x = (F.l2Norm u) ^ 2)
    (hResolvedAlign : resolvedEnergy E u x = dyadicResolvedEnergy F N u) :
    defectFlux E u x = dyadicObservable F N u := by
  unfold defectFlux dyadicObservable dyadicDefectEnergy
  rw [hTotalAlign, hResolvedAlign]


end StatMech.ContinuumField.NavierStokes
