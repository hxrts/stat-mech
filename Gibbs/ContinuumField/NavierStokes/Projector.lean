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
  /-- Output is divergence-free. -/
  divergenceFree_proj : ∀ u, IsDivergenceFree (proj u)

/-- Pointwise idempotence rewrite for the projector. -/
theorem leray_idempotent_apply {D : SpatialDomain3}
    (P : LerayProjector D) (u : VelocityField D) :
    P.proj (P.proj u) = P.proj u :=
  P.idempotent u

end Gibbs.ContinuumField.NavierStokes
