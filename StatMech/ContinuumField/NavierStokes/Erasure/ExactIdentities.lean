import StatMech.ContinuumField.NavierStokes.Erasure.Operators
import StatMech.ContinuumField.NavierStokes.Erasure.DyadicL2

/-! # Exact erasure identities

Exact algebraic identities for coarse/residual decomposition and defect terms.
This file also exposes `L2` decomposition bridges used by dyadic erasure paths.
-/

namespace StatMech.ContinuumField.NavierStokes

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
def projectorDefect {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) : VelocityField D :=
  E.map u - E.map (E.map u)

/-- Exact decomposition identity: `u = coarse + residual`. -/
theorem exact_decomposition {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) :
    u = coarseVelocity E u + residualVelocity E u := by
  simpa [coarseVelocity, residualVelocity, add_comm] using
    (resolved_plus_residual E u).symm

/-- Idempotent erasure implies zero projector defect exactly. -/
theorem projector_defect_zero_of_idempotent {D : SpatialDomain3} (E : ErasureOperator D)
    (u : VelocityField D) : projectorDefect E u = 0 := by
  funext x
  simp [projectorDefect, E.idempotent]

/-- Exact defect term in the coarse momentum equation. -/
def coarseMomentumDefect {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (E : ErasureOperator D)
    (u : VelocityField D)
    (p : PressureField D)
    (du_dt : VelocityField D) : VelocityField D :=
  E.map (MomentumResidual NS u p du_dt)
    - MomentumResidual NS (E.map u) p (E.map du_dt)

/-- Exact coarse equation identity: no approximation error is hidden. -/
theorem exact_coarse_momentum_identity {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (E : ErasureOperator D)
    (u : VelocityField D)
    (p : PressureField D)
    (du_dt : VelocityField D) :
    E.map (MomentumResidual NS u p du_dt) =
      MomentumResidual NS (E.map u) p (E.map du_dt)
        + coarseMomentumDefect NS E u p du_dt := by
  funext x
  simp [coarseMomentumDefect, sub_eq_add_neg]

/-- Defect identity in rearranged form used by continuation arguments. -/
theorem coarse_momentum_defect_eq_difference {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (E : ErasureOperator D)
    (u : VelocityField D)
    (p : PressureField D)
    (du_dt : VelocityField D) :
    coarseMomentumDefect NS E u p du_dt =
      E.map (MomentumResidual NS u p du_dt)
        - MomentumResidual NS (E.map u) p (E.map du_dt) :=
  rfl

/-- If legacy and dyadic maps align at scale `N`, residual components coincide. -/
theorem residual_eq_dyadicResidual_of_map_alignment {D : SpatialDomain3}
    (E : ErasureOperator D)
    (F : DyadicErasureFamily D)
    (N : Nat)
    (u : VelocityField D)
    (hMap : E.map u = F.atScale N u) :
    residualComponent E u = dyadicResidual F N u := by
  funext x
  simp [residualComponent, dyadicResidual, hMap]

/-- `L2` exact split from the dyadic projection-energy interface. -/
theorem exact_l2_split_from_dyadic {D : SpatialDomain3}
    (F : DyadicErasureFamily D)
    (N : Nat)
    (u : VelocityField D) :
    (F.l2Norm u) ^ 2 = dyadicResolvedEnergy F N u + dyadicDefectEnergy F N u :=
  dyadic_total_eq_resolved_plus_defect F N u

/-- Dyadic defect equals residual-square under the projection theorem package. -/
theorem exact_l2_defect_eq_residual_sq_from_dyadic {D : SpatialDomain3}
    {F : DyadicErasureFamily D}
    (A : DyadicProjectionL2Theorems F)
    (N : Nat)
    (u : VelocityField D) :
    dyadicDefectEnergy F N u = (F.l2Norm (dyadicResidual F N u)) ^ 2 :=
  dyadic_defectEnergy_eq_residual_sq (A := A) N u

end StatMech.ContinuumField.NavierStokes
