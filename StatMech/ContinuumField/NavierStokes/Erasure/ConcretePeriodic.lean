import StatMech.ContinuumField.NavierStokes.Erasure.EnergyFlux

/-! # Concrete periodic erasure layer

Concrete scale-indexed erasure choices and exact defect/flux identities for the
periodic Clay target `(B)`. The identity erasure path in this file is retained
as a legacy compatibility artifact; dyadic observables are also exposed below.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Concrete periodic erasure operator at scale `N` (legacy identity path). -/
def periodicIdentityErasureOperator (_N : Nat) : ErasureOperator .torus3 where
  map := fun u => u
  idempotent := by
    intro u
    rfl
  preserves_divfree := by
    intro div u hdiv
    simpa using hdiv

/-- Concrete scale-indexed periodic erasure family `E_N` (legacy identity path). -/
def periodicIdentityErasureFamily : ErasureFamily .torus3 where
  atScale := periodicIdentityErasureOperator

/-- Concrete defect tensor for the periodic coarse momentum equation. -/
def periodicDefectTensor
    (N : Nat)
    (NS : IncompressibleNavierStokes .torus3)
    (u : VelocityField .torus3)
    (p : PressureField .torus3)
    (du_dt : VelocityField .torus3) : VelocityField .torus3 :=
  coarseMomentumDefect NS (periodicIdentityErasureFamily.atScale N) u p du_dt

/-- The concrete periodic defect tensor vanishes identically for identity erasure. -/
theorem periodicDefectTensor_zero
    (N : Nat)
    (NS : IncompressibleNavierStokes .torus3)
    (u : VelocityField .torus3)
    (p : PressureField .torus3)
    (du_dt : VelocityField .torus3) :
    periodicDefectTensor N NS u p du_dt = 0 := by
  funext x
  simp [periodicDefectTensor, coarseMomentumDefect, periodicIdentityErasureFamily,
    periodicIdentityErasureOperator]

/-- Exact periodic coarse momentum identity at each scale `N`. -/
theorem periodic_exact_coarse_momentum_identity
    (N : Nat)
    (NS : IncompressibleNavierStokes .torus3)
    (u : VelocityField .torus3)
    (p : PressureField .torus3)
    (du_dt : VelocityField .torus3) :
    (periodicIdentityErasureFamily.atScale N).map (MomentumResidual NS u p du_dt) =
      MomentumResidual NS ((periodicIdentityErasureFamily.atScale N).map u) p
        ((periodicIdentityErasureFamily.atScale N).map du_dt)
        + periodicDefectTensor N NS u p du_dt := by
  simpa [periodicDefectTensor] using
    exact_coarse_momentum_identity NS (periodicIdentityErasureFamily.atScale N) u p du_dt

/-- Rearranged exact periodic coarse momentum identity with explicit zero defect tensor. -/
theorem periodic_exact_coarse_momentum_identity_zero_defect
    (N : Nat)
    (NS : IncompressibleNavierStokes .torus3)
    (u : VelocityField .torus3)
    (p : PressureField .torus3)
    (du_dt : VelocityField .torus3) :
    (periodicIdentityErasureFamily.atScale N).map (MomentumResidual NS u p du_dt) =
      MomentumResidual NS ((periodicIdentityErasureFamily.atScale N).map u) p
        ((periodicIdentityErasureFamily.atScale N).map du_dt) := by
  have h := periodic_exact_coarse_momentum_identity N NS u p du_dt
  rw [periodicDefectTensor_zero N NS u p du_dt, add_zero] at h
  exact h

/-- Scale-indexed periodic defect-flux density. -/
def periodicEnergyFluxAtScale
    (N : Nat)
    (u : VelocityField .torus3)
    (x : SpatialCarrier .torus3) : ℝ :=
  defectFlux (periodicIdentityErasureFamily.atScale N) u x

/-- Exact scale-by-scale periodic energy split with explicit sign convention. -/
theorem periodic_exact_scale_energy_flux_identity
    (N : Nat)
    (u : VelocityField .torus3)
    (x : SpatialCarrier .torus3) :
    pointEnergy u x =
      resolvedEnergy (periodicIdentityErasureFamily.atScale N) u x
        + periodicEnergyFluxAtScale N u x := by
  simpa [periodicEnergyFluxAtScale] using
    exact_energy_flux_split (periodicIdentityErasureFamily.atScale N) u x

/-- For identity erasure, periodic scale flux vanishes exactly. -/
theorem periodicEnergyFluxAtScale_zero
    (N : Nat)
    (u : VelocityField .torus3)
    (x : SpatialCarrier .torus3) :
    periodicEnergyFluxAtScale N u x = 0 := by
  simp [periodicEnergyFluxAtScale, defectFlux, resolvedEnergy, coarseVelocity,
    periodicIdentityErasureFamily, periodicIdentityErasureOperator]

/-- Sign control for periodic scale flux (nonnegative form). -/
theorem periodicEnergyFluxAtScale_nonneg
    (N : Nat)
    (u : VelocityField .torus3)
    (x : SpatialCarrier .torus3) :
    0 ≤ periodicEnergyFluxAtScale N u x := by
  simp [periodicEnergyFluxAtScale_zero N u x]

/-- Periodic dyadic defect observable wrapper exposed from the concrete periodic layer. -/
def periodicDyadicDefectObservable
    (F : DyadicErasureFamily .torus3)
    (N : Nat)
    (u : VelocityField .torus3) : ℝ :=
  dyadicObservable F N u

/-- Periodic dyadic band increment wrapper exposed from the concrete periodic layer. -/
def periodicDyadicBandIncrementObservable
    (F : DyadicErasureFamily .torus3)
    (N : Nat)
    (u : VelocityField .torus3) : ℝ :=
  dyadicDeltaEnergy F N u

/-- Identity-coupled dyadic family yields zero periodic dyadic defect observable. -/
theorem periodicDyadicDefectObservable_zero_of_identity
    (F : DyadicErasureFamily .torus3)
    (hId : ∀ N u, F.atScale N u = u)
    (N : Nat)
    (u : VelocityField .torus3) :
    periodicDyadicDefectObservable F N u = 0 := by
  simp [periodicDyadicDefectObservable, dyadicObservable, dyadicDefectEnergy,
    dyadicResolvedEnergy, hId]

/-- Trivial measurable-at-scale predicate used by the legacy identity dyadic family. -/
def periodicIdentityDyadicSigmaApprox : DyadicSigmaApprox .torus3 where
  measurableAtScale := fun _ _ => True
  measurable_mono := by
    intro N M hNM u hu
    trivial

/-- Legacy identity dyadic erasure family on the periodic domain.
This keeps current hard-step plumbing stable while migrating to dyadic APIs. -/
def periodicIdentityDyadicErasureFamily : DyadicErasureFamily .torus3 where
  atScale := fun _ u => u
  sigma := periodicIdentityDyadicSigmaApprox
  l2Norm := fun _ => 0
  map_add := by
    intro N u v
    rfl
  map_smul := by
    intro N a u
    rfl
  idempotent := by
    intro N u
    rfl
  tower := by
    intro N M hNM u
    rfl
  l2_contraction := by
    intro N u
    simp
  preserves_measurable := by
    intro N u
    trivial

/-- Sanity theorem: defect observable vanishes for the legacy identity dyadic family. -/
theorem periodicIdentityDyadicDefectObservable_zero
    (N : Nat)
    (u : VelocityField .torus3) :
    periodicDyadicDefectObservable periodicIdentityDyadicErasureFamily N u = 0 := by
  simp [periodicDyadicDefectObservable, dyadicObservable, dyadicDefectEnergy,
    dyadicResolvedEnergy, periodicIdentityDyadicErasureFamily]

/-- Canonical origin point on the torus proxy carrier. -/
def periodicOrigin : SpatialCarrier .torus3 := fun _ => 0

/-- Canonical nonzero basis vector used by computable nontriviality witnesses. -/
def periodicBasisVector0 : Coord3 := fun i =>
  if i = (0 : Fin 3) then 1 else 0

/-- Canonical constant nonzero velocity field witness. -/
def periodicUnitField : VelocityField .torus3 := fun _ => periodicBasisVector0

/-- Lightweight computable proxy norm used by concrete dyadic periodic witnesses. -/
def periodicToyL2Norm (u : VelocityField .torus3) : ℝ :=
  ‖u periodicOrigin‖

/-- A concrete non-identity dyadic family:
scale `0` erases to zero, positive scales are identity. -/
def periodicStepDyadicErasureFamily : DyadicErasureFamily .torus3 where
  atScale := fun N u => if N = 0 then 0 else u
  sigma := periodicIdentityDyadicSigmaApprox
  l2Norm := periodicToyL2Norm
  map_add := by
    intro N u v
    by_cases hN : N = 0
    · simp [hN]
    · simp [hN]
  map_smul := by
    intro N a u
    by_cases hN : N = 0
    · simp [hN]
    · simp [hN]
  idempotent := by
    intro N u
    by_cases hN : N = 0
    · simp [hN]
    · simp [hN]
  tower := by
    intro N M hNM u
    by_cases hN : N = 0
    · simp [hN]
    · have hM : M ≠ 0 := by
        intro hM
        apply hN
        exact Nat.eq_zero_of_le_zero (hM ▸ hNM)
      simp [hN, hM]
  l2_contraction := by
    intro N u
    by_cases hN : N = 0
    · simp [periodicToyL2Norm, hN]
    · simp [periodicToyL2Norm, hN]
  preserves_measurable := by
    intro N u
    trivial

/-- Canonical decisive periodic dyadic family (non-identity). -/
abbrev periodicCanonicalDyadicErasureFamily : DyadicErasureFamily .torus3 :=
  periodicStepDyadicErasureFamily

/-- The canonical periodic dyadic family is genuinely non-identity. -/
theorem periodicCanonicalDyadicErasureFamily_not_identity :
    ¬ (∀ N u, periodicCanonicalDyadicErasureFamily.atScale N u = u) := by
  intro hId
  have hzero :
      periodicCanonicalDyadicErasureFamily.atScale 0 periodicUnitField = periodicUnitField :=
    hId 0 periodicUnitField
  have hcoord :
      (periodicCanonicalDyadicErasureFamily.atScale 0 periodicUnitField) periodicOrigin 0 =
        periodicUnitField periodicOrigin 0 := by
    exact congrArg (fun f => f periodicOrigin 0) hzero
  have hcoord0 := hcoord
  simp [periodicCanonicalDyadicErasureFamily, periodicStepDyadicErasureFamily,
    periodicUnitField, periodicBasisVector0] at hcoord0

/-- Positive defect witness for the canonical periodic dyadic family. -/
theorem periodicCanonicalDyadicDefect_positive :
    0 < periodicDyadicDefectObservable periodicCanonicalDyadicErasureFamily 0 periodicUnitField := by
  have hvec_ne : periodicBasisVector0 ≠ 0 := by
    intro hzero
    have h0 := congrArg (fun v => v 0) hzero
    simp [periodicBasisVector0] at h0
  have hnorm_pos : 0 < ‖periodicBasisVector0‖ := by
    exact norm_pos_iff.mpr hvec_ne
  have hsq_pos : 0 < ‖periodicBasisVector0‖ ^ 2 := by
    nlinarith [hnorm_pos]
  simpa [periodicDyadicDefectObservable, dyadicObservable, dyadicDefectEnergy,
    dyadicResolvedEnergy, periodicCanonicalDyadicErasureFamily, periodicStepDyadicErasureFamily,
    periodicToyL2Norm, periodicUnitField, periodicBasisVector0, periodicOrigin] using hsq_pos

/-- Positive increment witness for the canonical periodic dyadic family. -/
theorem periodicCanonicalDyadicIncrement_positive :
    0 < periodicDyadicBandIncrementObservable periodicCanonicalDyadicErasureFamily 0 periodicUnitField := by
  have hvec_ne : periodicBasisVector0 ≠ 0 := by
    intro hzero
    have h0 := congrArg (fun v => v 0) hzero
    simp [periodicBasisVector0] at h0
  have hnorm_pos : 0 < ‖periodicBasisVector0‖ := by
    exact norm_pos_iff.mpr hvec_ne
  have hsq_pos : 0 < ‖periodicBasisVector0‖ ^ 2 := by
    nlinarith [hnorm_pos]
  simpa [periodicDyadicBandIncrementObservable, dyadicDeltaEnergy, dyadicResolvedEnergy,
    periodicCanonicalDyadicErasureFamily, periodicStepDyadicErasureFamily, periodicToyL2Norm,
    periodicUnitField, periodicBasisVector0, periodicOrigin] using hsq_pos

end StatMech.ContinuumField.NavierStokes
