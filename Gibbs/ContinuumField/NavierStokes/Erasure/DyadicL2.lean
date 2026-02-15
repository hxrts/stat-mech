import Gibbs.ContinuumField.NavierStokes.Erasure.DyadicCore

/-! # Dyadic `L2` projection-energy interfaces

Abstract residual/projection identities and energy monotonicity interfaces for
dyadic erasure families.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Dyadic residual `R_N u := u - E_N u`. -/
def dyadicResidual {D : SpatialDomain3} (F : DyadicErasureFamily D)
    (N : Nat) (u : VelocityField D) : VelocityField D :=
  u - F.atScale N u

/-- Exact decomposition `u = E_N u + R_N u`. -/
theorem dyadic_resolved_plus_residual {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (N : Nat) (u : VelocityField D) :
    F.atScale N u + dyadicResidual F N u = u := by
  funext x
  simp [dyadicResidual]

/-- Resolved dyadic `L2` energy at scale `N`. -/
def dyadicResolvedEnergy {D : SpatialDomain3} (F : DyadicErasureFamily D)
    (N : Nat) (u : VelocityField D) : ℝ :=
  (F.l2Norm (F.atScale N u)) ^ 2

/-- Dyadic defect `L2` energy at scale `N`. -/
def dyadicDefectEnergy {D : SpatialDomain3} (F : DyadicErasureFamily D)
    (N : Nat) (u : VelocityField D) : ℝ :=
  (F.l2Norm u) ^ 2 - dyadicResolvedEnergy F N u

/-- Placeholder orthogonality predicate for resolved/residual components.
This stays abstract at this interface layer and is refined downstream. -/
def dyadicOrthogonalityPred {D : SpatialDomain3} (_F : DyadicErasureFamily D)
    (_N : Nat) (_u : VelocityField D) : Prop :=
  True

/-- Abstract theorem package for dyadic `L2` projection identities. -/
structure DyadicProjectionL2Theorems {D : SpatialDomain3}
    (F : DyadicErasureFamily D) where
  /-- Orthogonality of resolved/residual components (kept abstract at this layer). -/
  orthogonality : ∀ (N : Nat) (u : VelocityField D), dyadicOrthogonalityPred F N u
  /-- Pythagorean identity for projection plus residual. -/
  pythagorean : ∀ (N : Nat) (u : VelocityField D),
    (F.l2Norm u) ^ 2 =
      (F.l2Norm (F.atScale N u)) ^ 2 + (F.l2Norm (dyadicResidual F N u)) ^ 2
  /-- Resolved-energy monotonicity under refinement. -/
  resolved_monotone : ∀ {N M : Nat}, DyadicRefines N M → ∀ u,
    dyadicResolvedEnergy F N u ≤ dyadicResolvedEnergy F M u
  /-- Defect-energy monotonicity under refinement (nonincreasing). -/
  defect_monotone : ∀ {N M : Nat}, DyadicRefines N M → ∀ u,
    dyadicDefectEnergy F M u ≤ dyadicDefectEnergy F N u

/-- Orthogonality theorem API. -/
theorem dyadic_orthogonality {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    (N : Nat) (u : VelocityField D) :
    dyadicOrthogonalityPred F N u :=
  A.orthogonality N u

/-- Pythagorean identity theorem API. -/
theorem dyadic_pythagorean {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    (N : Nat) (u : VelocityField D) :
    (F.l2Norm u) ^ 2 =
      (F.l2Norm (F.atScale N u)) ^ 2 + (F.l2Norm (dyadicResidual F N u)) ^ 2 :=
  A.pythagorean N u

/-- Exact split theorem `total = resolved + defect`. -/
theorem dyadic_total_eq_resolved_plus_defect {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (N : Nat) (u : VelocityField D) :
    (F.l2Norm u) ^ 2 = dyadicResolvedEnergy F N u + dyadicDefectEnergy F N u := by
  simp [dyadicResolvedEnergy, dyadicDefectEnergy, sub_eq_add_neg, add_comm, add_left_comm]

/-- Defect energy is exactly residual energy under the Pythagorean law. -/
theorem dyadic_defectEnergy_eq_residual_sq {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    (N : Nat) (u : VelocityField D) :
    dyadicDefectEnergy F N u = (F.l2Norm (dyadicResidual F N u)) ^ 2 := by
  calc
    dyadicDefectEnergy F N u
        = (F.l2Norm u) ^ 2 - (F.l2Norm (F.atScale N u)) ^ 2 := rfl
    _ = ((F.l2Norm (F.atScale N u)) ^ 2 + (F.l2Norm (dyadicResidual F N u)) ^ 2)
        - (F.l2Norm (F.atScale N u)) ^ 2 := by
          simp [A.pythagorean N u]
    _ = (F.l2Norm (dyadicResidual F N u)) ^ 2 := by
          simp [sub_eq_add_neg, add_assoc, add_comm]

/-- Defect energy is nonnegative under the projection theorem package. -/
theorem dyadic_defectEnergy_nonneg {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    (N : Nat) (u : VelocityField D) :
    0 ≤ dyadicDefectEnergy F N u := by
  simpa [dyadic_defectEnergy_eq_residual_sq (A := A) N u] using
    sq_nonneg (F.l2Norm (dyadicResidual F N u))

/-- Defect energy vanishes iff the residual `L2` norm vanishes. -/
theorem dyadic_defectEnergy_eq_zero_iff_residual_norm_eq_zero {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    (N : Nat) (u : VelocityField D) :
    dyadicDefectEnergy F N u = 0 ↔ F.l2Norm (dyadicResidual F N u) = 0 := by
  constructor
  · intro hDef
    have hsq : (F.l2Norm (dyadicResidual F N u)) ^ 2 = 0 := by
      simpa [dyadic_defectEnergy_eq_residual_sq (A := A) N u] using hDef
    exact sq_eq_zero_iff.mp hsq
  · intro hRes
    simp [dyadic_defectEnergy_eq_residual_sq (A := A) N u, hRes]

/-- Resolved-energy monotonicity theorem API. -/
theorem dyadic_resolvedEnergy_mono {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    {N M : Nat} (hNM : DyadicRefines N M) (u : VelocityField D) :
    dyadicResolvedEnergy F N u ≤ dyadicResolvedEnergy F M u :=
  A.resolved_monotone hNM u

/-- Defect-energy monotonicity theorem API. -/
theorem dyadic_defectEnergy_mono {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    {N M : Nat} (hNM : DyadicRefines N M) (u : VelocityField D) :
    dyadicDefectEnergy F M u ≤ dyadicDefectEnergy F N u :=
  A.defect_monotone hNM u


/-- Optional theorem package relating defect vanishing to dyadic measurability. -/
structure DyadicMeasurabilityTheorems {D : SpatialDomain3}
    (F : DyadicErasureFamily D)
    (_A : DyadicProjectionL2Theorems F) where
  zero_defect_iff_measurable : ∀ (N : Nat) (u : VelocityField D),
    dyadicDefectEnergy F N u = 0 ↔ F.sigma.measurableAtScale N u

/-- API theorem: zero defect iff scale-measurable under the optional package. -/
theorem dyadic_zero_defect_iff_measurable {D : SpatialDomain3}
    {F : DyadicErasureFamily D}
    (A : DyadicProjectionL2Theorems F)
    (M : DyadicMeasurabilityTheorems F A)
    (N : Nat)
    (u : VelocityField D) :
    dyadicDefectEnergy F N u = 0 ↔ F.sigma.measurableAtScale N u :=
  M.zero_defect_iff_measurable N u
end Gibbs.ContinuumField.NavierStokes
