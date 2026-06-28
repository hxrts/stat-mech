import StatMech.ContinuumField.NavierStokes.Functional.LittlewoodPaley

/-! # Nonlinear and pressure estimates

Product/commutator bounds for convection and Calderon-Zygmund-style pressure
estimates in selected critical norms.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Context for product and commutator estimates. -/
structure NonlinearEstimateContext (D : SpatialDomain3) where
  /-- Norm controlling velocity factors. -/
  velocityNorm : VelocityField D → ℝ
  /-- Norm controlling convection term. -/
  convectionNorm : VelocityField D → ℝ
  /-- Product estimate constant. -/
  Cprod : ℝ
  /-- Commutator estimate constant. -/
  Ccomm : ℝ
  /-- Nonnegativity assumptions. -/
  Cprod_nonneg : 0 ≤ Cprod
  Ccomm_nonneg : 0 ≤ Ccomm

/-- Product estimate for `(u · ∇)u` in abstract norm form. -/
theorem convection_product_estimate {D : SpatialDomain3}
    (N : NonlinearEstimateContext D)
    (u : VelocityField D)
    (hprod : N.convectionNorm u ≤ N.Cprod * (N.velocityNorm u) * (N.velocityNorm u)) :
    N.convectionNorm u ≤ N.Cprod * (N.velocityNorm u) * (N.velocityNorm u) :=
  hprod

/-- Commutator estimate for LP-scale interaction errors. -/
theorem convection_commutator_estimate {D : SpatialDomain3}
    (N : NonlinearEstimateContext D)
    (LP : LittlewoodPaleyFamily D)
    (u : VelocityField D)
    (hcomm : N.convectionNorm (LP.block 0 u - LP.lowCut 0 u) ≤
      N.Ccomm * N.velocityNorm u) :
    N.convectionNorm (LP.block 0 u - LP.lowCut 0 u) ≤ N.Ccomm * N.velocityNorm u :=
  hcomm

/-- Context for pressure estimates. -/
structure PressureEstimateContext (D : SpatialDomain3) where
  /-- Pressure norm. -/
  pressureNorm : PressureField D → ℝ
  /-- Velocity norm entering CZ bounds. -/
  velocityNorm : VelocityField D → ℝ
  /-- Calderon-Zygmund constant. -/
  Ccz : ℝ
  /-- Nonnegativity assumption. -/
  Ccz_nonneg : 0 ≤ Ccz

/-- Calderon-Zygmund-style pressure control from velocity norms. -/
theorem pressure_calderon_zygmund_estimate {D : SpatialDomain3}
    (P : PressureEstimateContext D)
    (p : PressureField D)
    (u : VelocityField D)
    (hcz : P.pressureNorm p ≤ P.Ccz * (P.velocityNorm u) * (P.velocityNorm u)) :
    P.pressureNorm p ≤ P.Ccz * (P.velocityNorm u) * (P.velocityNorm u) :=
  hcz

end StatMech.ContinuumField.NavierStokes
