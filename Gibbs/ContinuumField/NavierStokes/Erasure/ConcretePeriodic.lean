import Gibbs.ContinuumField.NavierStokes.Erasure.EnergyFlux

/-! # Concrete periodic erasure layer

Concrete scale-indexed erasure choices and exact defect/flux identities for the
periodic Clay target `(B)`.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical
noncomputable section

/-- Concrete periodic erasure operator at scale `N` (identity first pass). -/
def periodicIdentityErasureOperator (_N : Nat) : ErasureOperator .torus3 where
  map := fun u => u
  idempotent := by
    intro u
    rfl
  preserves_divfree := by
    intro div u hdiv
    simpa using hdiv

/-- Concrete scale-indexed periodic erasure family `E_N`. -/
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

end
end Gibbs.ContinuumField.NavierStokes
