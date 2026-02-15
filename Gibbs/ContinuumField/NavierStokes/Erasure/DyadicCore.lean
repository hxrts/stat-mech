import Gibbs.ContinuumField.NavierStokes.Erasure.Operators

/-! # Dyadic erasure core interfaces

Core interfaces for dyadic conditional-expectation style coarse-graining.
This file stays abstract: concrete constructions can instantiate these objects.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Dyadic refinement relation (`N <= M` means `M` is at least as fine as `N`). -/
abbrev DyadicRefines (N M : Nat) : Prop := N ≤ M

/-- Dyadic refinement is reflexive. -/
theorem dyadicRefines_refl (N : Nat) : DyadicRefines N N := le_rfl

/-- Dyadic refinement is transitive. -/
theorem dyadicRefines_trans {N M K : Nat}
    (hNM : DyadicRefines N M) (hMK : DyadicRefines M K) :
    DyadicRefines N K := by
  exact le_trans hNM hMK

/-- Scale-indexed dyadic partition data. -/
structure DyadicPartitionData (D : SpatialDomain3) where
  /-- Cell index map at each dyadic scale. -/
  cellIndex : Nat → SpatialCarrier D → Nat
  /-- If two points are in the same finer cell, they are in the same coarser cell. -/
  refinement : ∀ {N M : Nat}, DyadicRefines N M →
    ∀ {x y : SpatialCarrier D}, cellIndex M x = cellIndex M y → cellIndex N x = cellIndex N y

/-- Scale-indexed measurable-at-scale abstraction. -/
structure DyadicSigmaApprox (D : SpatialDomain3) where
  /-- Predicate: field is measurable with respect to scale `N`. -/
  measurableAtScale : Nat → VelocityField D → Prop
  /-- Monotonicity under dyadic refinement. -/
  measurable_mono : ∀ {N M : Nat}, DyadicRefines N M →
    ∀ {u : VelocityField D}, measurableAtScale N u → measurableAtScale M u

/-- Measurability monotonicity API theorem. -/
theorem measurableAtScale_mono {D : SpatialDomain3}
    (S : DyadicSigmaApprox D)
    {N M : Nat} (hNM : DyadicRefines N M)
    {u : VelocityField D} (hu : S.measurableAtScale N u) :
    S.measurableAtScale M u :=
  S.measurable_mono hNM hu

/-- Abstract dyadic erasure family with `L2`-control and measurability laws. -/
structure DyadicErasureFamily (D : SpatialDomain3) where
  /-- Dyadic coarse-graining operator `E_N`. -/
  atScale : Nat → VelocityField D → VelocityField D
  /-- Measurability abstraction used for closure statements. -/
  sigma : DyadicSigmaApprox D
  /-- Abstract `L2` norm functional used by contraction laws. -/
  l2Norm : VelocityField D → ℝ
  /-- Linearity (addition). -/
  map_add : ∀ N u v, atScale N (u + v) = atScale N u + atScale N v
  /-- Linearity (scalar multiplication). -/
  map_smul : ∀ N (a : ℝ) u, atScale N (a • u) = a • atScale N u
  /-- Idempotence of projection/conditional expectation at fixed scale. -/
  idempotent : ∀ N u, atScale N (atScale N u) = atScale N u
  /-- Tower/refinement law for dyadic conditional expectations. -/
  tower : ∀ {N M : Nat}, DyadicRefines N M → ∀ u, atScale N (atScale M u) = atScale N u
  /-- `L2` contraction at every dyadic scale. -/
  l2_contraction : ∀ N u, l2Norm (atScale N u) ≤ l2Norm u
  /-- Measurability closure at every dyadic scale. -/
  preserves_measurable : ∀ N u, sigma.measurableAtScale N (atScale N u)

/-- Dyadic erasure linearity theorem (`E_N(u+v)=E_Nu+E_Nv`). -/
theorem dyadicErasure_map_add {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (N : Nat) (u v : VelocityField D) :
    F.atScale N (u + v) = F.atScale N u + F.atScale N v :=
  F.map_add N u v

/-- Dyadic erasure linearity theorem (`E_N(au)=aE_Nu`). -/
theorem dyadicErasure_map_smul {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (N : Nat) (a : ℝ) (u : VelocityField D) :
    F.atScale N (a • u) = a • F.atScale N u :=
  F.map_smul N a u

/-- Dyadic erasure idempotence theorem. -/
theorem dyadicErasure_idempotent {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (N : Nat) (u : VelocityField D) :
    F.atScale N (F.atScale N u) = F.atScale N u :=
  F.idempotent N u

/-- Dyadic erasure tower/refinement theorem. -/
theorem dyadicErasure_tower {D : SpatialDomain3}
    (F : DyadicErasureFamily D)
    {N M : Nat} (hNM : DyadicRefines N M) (u : VelocityField D) :
    F.atScale N (F.atScale M u) = F.atScale N u :=
  F.tower hNM u

/-- Dyadic erasure `L2` contraction theorem. -/
theorem dyadicErasure_l2_contraction {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (N : Nat) (u : VelocityField D) :
    F.l2Norm (F.atScale N u) ≤ F.l2Norm u :=
  F.l2_contraction N u

/-- Dyadic erasure measurability closure theorem. -/
theorem dyadicErasure_preserves_measurable {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (N : Nat) (u : VelocityField D) :
    F.sigma.measurableAtScale N (F.atScale N u) :=
  F.preserves_measurable N u

end Gibbs.ContinuumField.NavierStokes
