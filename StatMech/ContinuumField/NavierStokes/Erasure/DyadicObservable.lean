import StatMech.ContinuumField.NavierStokes.Erasure.DyadicL2

/-! # Dyadic observables

Observable layer for dyadic erasure energies: global defect, scale increments,
and localized weighted variants.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical global dyadic erasure observable (defect energy). -/
def dyadicObservable {D : SpatialDomain3} (F : DyadicErasureFamily D)
    (N : Nat) (u : VelocityField D) : ℝ :=
  dyadicDefectEnergy F N u

/-- Dyadic band increment observable between scales `N` and `N+1`. -/
def dyadicDeltaEnergy {D : SpatialDomain3} (F : DyadicErasureFamily D)
    (N : Nat) (u : VelocityField D) : ℝ :=
  dyadicResolvedEnergy F (N + 1) u - dyadicResolvedEnergy F N u

/-- Finite dyadic increment sum from scale `N` over a window of length `K+1`. -/
def dyadicIncrementSum {D : SpatialDomain3} (F : DyadicErasureFamily D)
    (N K : Nat) (u : VelocityField D) : ℝ :=
  Nat.rec (motive := fun _ => ℝ)
    (dyadicDeltaEnergy F N u)
    (fun k acc => acc + dyadicDeltaEnergy F (N + k + 1) u) K

/-- Nonnegative cutoff package for localized observables. -/
structure LocalCutoff (D : SpatialDomain3) where
  weight : SpatialCarrier D → ℝ
  nonneg : ∀ x, 0 ≤ weight x

/-- Localized weighted dyadic defect observable (abstract weighted form). -/
def dyadicLocalizedObservable {D : SpatialDomain3}
    (F : DyadicErasureFamily D)
    (_phi : LocalCutoff D)
    (N : Nat) (u : VelocityField D) : ℝ :=
  dyadicDefectEnergy F N u

/-- Abstract theorem package for dyadic increment/tail controls. -/
structure DyadicIncrementTheorems {D : SpatialDomain3}
    (F : DyadicErasureFamily D) where
  /-- Scale increment is nonnegative. -/
  delta_nonneg : ∀ N u, 0 ≤ dyadicDeltaEnergy F N u
  /-- Finite telescoping identity over dyadic increments. -/
  telescoping : ∀ N K u,
    dyadicIncrementSum F N K u
      = dyadicResolvedEnergy F (N + K + 1) u - dyadicResolvedEnergy F N u
  /-- Global bound for dyadic increment tails by total energy. -/
  tail_bound_by_total : ∀ N K u,
    dyadicIncrementSum F N K u ≤ (F.l2Norm u) ^ 2

/-- API theorem for dyadic increment nonnegativity. -/
theorem dyadicDeltaEnergy_nonneg {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (T : DyadicIncrementTheorems F)
    (N : Nat) (u : VelocityField D) :
    0 ≤ dyadicDeltaEnergy F N u :=
  T.delta_nonneg N u

/-- API theorem for finite dyadic telescoping sums. -/
theorem dyadicIncrementSum_telescoping {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (T : DyadicIncrementTheorems F)
    (N K : Nat) (u : VelocityField D) :
    dyadicIncrementSum F N K u
      = dyadicResolvedEnergy F (N + K + 1) u - dyadicResolvedEnergy F N u :=
  T.telescoping N K u

/-- API theorem for finite dyadic tail bounded by total energy. -/
theorem dyadicIncrementSum_le_totalEnergy {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (T : DyadicIncrementTheorems F)
    (N K : Nat) (u : VelocityField D) :
    dyadicIncrementSum F N K u ≤ (F.l2Norm u) ^ 2 :=
  T.tail_bound_by_total N K u

/-- The global dyadic observable is nonnegative under projection-energy assumptions. -/
theorem dyadicObservable_nonneg {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (A : DyadicProjectionL2Theorems F)
    (N : Nat) (u : VelocityField D) :
    0 ≤ dyadicObservable F N u := by
  simpa [dyadicObservable] using dyadic_defectEnergy_nonneg (A := A) N u

/-- Localized dyadic observable inherits nonnegativity at this interface layer. -/
theorem dyadicLocalizedObservable_nonneg {D : SpatialDomain3}
    {F : DyadicErasureFamily D} (_phi : LocalCutoff D)
    (A : DyadicProjectionL2Theorems F)
    (N : Nat) (u : VelocityField D) :
    0 ≤ dyadicLocalizedObservable F _phi N u := by
  simpa [dyadicLocalizedObservable] using dyadic_defectEnergy_nonneg (A := A) N u

/-- Localized split identity inherits the global resolved/defect decomposition. -/
theorem dyadicLocalized_total_eq_resolved_plus_observable {D : SpatialDomain3}
    (F : DyadicErasureFamily D) (phi : LocalCutoff D)
    (N : Nat) (u : VelocityField D) :
    (F.l2Norm u) ^ 2
      = dyadicResolvedEnergy F N u + dyadicLocalizedObservable F phi N u := by
  simpa [dyadicLocalizedObservable] using dyadic_total_eq_resolved_plus_defect F N u


/-- Optional theorem package for localized observable stability under refinement. -/
structure DyadicLocalizedStabilityTheorems {D : SpatialDomain3}
    (F : DyadicErasureFamily D) where
  localization_stable : ∀ (phi : LocalCutoff D) {N M : Nat},
    DyadicRefines N M → ∀ u,
      dyadicLocalizedObservable F phi M u ≤ dyadicLocalizedObservable F phi N u

/-- API theorem: localized observable stability under dyadic refinement. -/
theorem dyadicLocalizedObservable_stable_under_refinement {D : SpatialDomain3}
    {F : DyadicErasureFamily D}
    (S : DyadicLocalizedStabilityTheorems F)
    (phi : LocalCutoff D)
    {N M : Nat}
    (hNM : DyadicRefines N M)
    (u : VelocityField D) :
    dyadicLocalizedObservable F phi M u ≤ dyadicLocalizedObservable F phi N u :=
  S.localization_stable phi hNM u
end StatMech.ContinuumField.NavierStokes
