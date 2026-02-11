import Gibbs.ContinuumField.NavierStokes.Functional.CriticalSpace

/-!
# Littlewood-Paley and paraproduct interfaces

Abstract LP-block machinery for nonlinear decomposition estimates.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Littlewood-Paley decomposition family. -/
structure LittlewoodPaleyFamily (D : SpatialDomain3) where
  /-- Dyadic block operator `Δ_j`. -/
  block : Int → VelocityField D → VelocityField D
  /-- Low-frequency cutoff `S_j`. -/
  lowCut : Int → VelocityField D → VelocityField D
  /-- Reconstruction hypothesis in interface form. -/
  reconstructs : Prop

/-- Paraproduct left term `T_u v` (interface-level placeholder). -/
def paraproductLeft {D : SpatialDomain3} (LP : LittlewoodPaleyFamily D)
    (u v : VelocityField D) : VelocityField D :=
  LP.lowCut 0 u + LP.block 0 v

/-- Paraproduct right term `T_v u` (interface-level placeholder). -/
def paraproductRight {D : SpatialDomain3} (LP : LittlewoodPaleyFamily D)
    (u v : VelocityField D) : VelocityField D :=
  LP.lowCut 0 v + LP.block 0 u

/-- Resonant term `R(u,v)` (interface-level placeholder). -/
def paraproductResonant {D : SpatialDomain3} (LP : LittlewoodPaleyFamily D)
    (u v : VelocityField D) : VelocityField D :=
  LP.block 0 u + LP.block 0 v

/-- Decomposition theorem in assumption-driven form. -/
theorem paraproduct_decomposition {D : SpatialDomain3}
    (LP : LittlewoodPaleyFamily D)
    (u v : VelocityField D)
    (hdecomp : u + v =
      paraproductLeft LP u v + paraproductRight LP u v + paraproductResonant LP u v) :
    u + v =
      paraproductLeft LP u v + paraproductRight LP u v + paraproductResonant LP u v :=
  hdecomp

end Gibbs.ContinuumField.NavierStokes
