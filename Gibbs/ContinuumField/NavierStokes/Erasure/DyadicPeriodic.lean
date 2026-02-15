import Gibbs.ContinuumField.NavierStokes.Erasure.DyadicObservable
import Gibbs.ContinuumField.NavierStokes.Erasure.ConcretePeriodic

/-! # Dyadic periodic observable interfaces

Periodic-domain wrappers around dyadic erasure observables, plus compatibility
bridges to legacy pointwise periodic flux statements.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical periodic dyadic defect observable at scale `N`. -/
def periodicDyadicDefectAtScale
    (F : DyadicErasureFamily .torus3)
    (N : Nat)
    (u : VelocityField .torus3) : ℝ :=
  dyadicObservable F N u

/-- Canonical periodic dyadic band increment observable at scale `N`. -/
def periodicDyadicBandIncrement
    (F : DyadicErasureFamily .torus3)
    (N : Nat)
    (u : VelocityField .torus3) : ℝ :=
  dyadicDeltaEnergy F N u

/-- If `E_N` is the identity at every scale, periodic dyadic defect vanishes. -/
theorem periodicDyadicDefectAtScale_zero_of_identity
    (F : DyadicErasureFamily .torus3)
    (hId : ∀ N u, F.atScale N u = u)
    (N : Nat)
    (u : VelocityField .torus3) :
    periodicDyadicDefectAtScale F N u = 0 := by
  simp [periodicDyadicDefectAtScale, dyadicObservable, dyadicDefectEnergy,
    dyadicResolvedEnergy, hId]

/-- Legacy pointwise periodic flux coincides with dyadic defect under identity coupling.
This is a compatibility bridge while hard-step modules migrate away from pointwise flux. -/
theorem periodicLegacyFlux_eq_dyadicDefect_of_identity
    (F : DyadicErasureFamily .torus3)
    (hId : ∀ N u, F.atScale N u = u)
    (N : Nat)
    (u : VelocityField .torus3)
    (x : SpatialCarrier .torus3) :
    periodicEnergyFluxAtScale N u x = periodicDyadicDefectAtScale F N u := by
  rw [periodicEnergyFluxAtScale_zero N u x,
    periodicDyadicDefectAtScale_zero_of_identity F hId N u]

/-- Nontriviality interface expected by dyadic hard-step assumptions on the periodic domain. -/
structure PeriodicDyadicNontrivialityData (F : DyadicErasureFamily .torus3) where
  /-- At least one scale/state pair has strictly positive defect observable. -/
  positive_defect : ∃ (N : Nat) (u : VelocityField .torus3),
    0 < periodicDyadicDefectAtScale F N u
  /-- At least one scale/state pair has strictly positive band increment. -/
  positive_increment : ∃ (N : Nat) (u : VelocityField .torus3),
    0 < periodicDyadicBandIncrement F N u

/-- API theorem exposing positive periodic dyadic defect witness. -/
theorem periodicDyadic_exists_positive_defect
    {F : DyadicErasureFamily .torus3}
    (H : PeriodicDyadicNontrivialityData F) :
    ∃ (N : Nat) (u : VelocityField .torus3), 0 < periodicDyadicDefectAtScale F N u :=
  H.positive_defect

/-- API theorem exposing positive periodic dyadic increment witness. -/
theorem periodicDyadic_exists_positive_increment
    {F : DyadicErasureFamily .torus3}
    (H : PeriodicDyadicNontrivialityData F) :
    ∃ (N : Nat) (u : VelocityField .torus3), 0 < periodicDyadicBandIncrement F N u :=
  H.positive_increment

/-- Canonical periodic family satisfies the dyadic nontriviality interface. -/
theorem periodicCanonicalDyadicNontrivialityData :
    PeriodicDyadicNontrivialityData periodicCanonicalDyadicErasureFamily := by
  refine ⟨?_, ?_⟩
  · refine ⟨0, periodicUnitField, ?_⟩
    simpa [periodicDyadicDefectAtScale, periodicDyadicDefectObservable] using
      periodicCanonicalDyadicDefect_positive
  · refine ⟨0, periodicUnitField, ?_⟩
    simpa [periodicDyadicBandIncrement, periodicDyadicBandIncrementObservable] using
      periodicCanonicalDyadicIncrement_positive

end Gibbs.ContinuumField.NavierStokes
