import Gibbs.ContinuumField.NavierStokes.Equation

/-!
# Leray projector interface

Abstract Leray projection interface used by pressure-eliminated formulations.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Abstract Leray projector for divergence-free projection. -/
structure LerayProjector (D : SpatialDomain3) where
  /-- Projection operator. -/
  proj : VelocityField D → VelocityField D
  /-- Idempotence law. -/
  idempotent : ∀ u, proj (proj u) = proj u
  /-- Output is divergence-free for the chosen divergence operator. -/
  divergenceFree_proj : (div : VelocityField D → ScalarField D) →
    ∀ u, IsDivergenceFreeWith div (proj u)

/-- Pointwise idempotence rewrite for the projector. -/
theorem leray_idempotent_apply {D : SpatialDomain3}
    (P : LerayProjector D) (u : VelocityField D) :
    P.proj (P.proj u) = P.proj u :=
  P.idempotent u

/-- Leray projector removes pressure-gradient terms in projected dynamics. -/
def projectedMomentumResidual {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D) (P : LerayProjector D)
    (u : VelocityField D) (du_dt : VelocityField D) : VelocityField D :=
  P.proj (du_dt + NS.ops.convection u - NS.nu • NS.ops.laplace u - NS.forcing)

/-- Pressure-free projected equation predicate. -/
def SatisfiesProjectedEquation {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D) (P : LerayProjector D)
    (u : VelocityField D) (du_dt : VelocityField D) : Prop :=
  projectedMomentumResidual NS P u du_dt = 0

end Gibbs.ContinuumField.NavierStokes
