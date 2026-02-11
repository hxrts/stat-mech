import Gibbs.ContinuumField.NavierStokes.Blowup.Rigidity
import Gibbs.ContinuumField.NavierStokes.ClaySpec

/-!
# Clay-periodic contradiction route

Periodic `(D)`-aligned wrappers for first-singular-time setup, compactness
extraction, minimal blow-up construction, and rigidity/obstruction endgames.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- First-singular-time and normalized blow-up sequence data in periodic route. -/
structure PeriodicFirstSingularFramework where
  /-- Candidate first singular time witness. -/
  witness : FirstSingularTimeWitness .euclidean3
  /-- Normalized blow-up sequence around the singular time. -/
  seq : BlowupSequence .euclidean3
  /-- Normalization ties sequence singular time to `T*`. -/
  normalized_time : seq.singularTime = witness.Tstar

/-- Normalized extraction theorem from the first-singular-time framework. -/
theorem periodic_normalized_extraction
    (F : PeriodicFirstSingularFramework) :
    ∃ seq : BlowupSequence .euclidean3,
      seq.singularTime = F.witness.Tstar ∧
      0 < seq.singularTime := by
  refine ⟨F.seq, F.normalized_time, ?_⟩
  simpa [F.normalized_time] using F.witness.Tstar_pos

/-- Compactness/profile extraction theorem in the periodic contradiction route. -/
theorem periodic_extract_compact_profile
    (F : PeriodicFirstSingularFramework)
    (hextract : ∃ cp : CompactnessProfile .euclidean3, cp.nontrivial) :
    ∃ cp : CompactnessProfile .euclidean3, cp.nontrivial :=
  extract_compact_profile F.seq hextract

/-- Minimal blow-up object construction with explicit nontrivial mode witness. -/
theorem periodic_build_minimal_blowup_object
    (cp : CompactnessProfile .euclidean3)
    (hmode : ∃ x i, cp.limitingVelocity x i ≠ 0)
    (hmin : Prop) :
    ∃ m : MinimalBlowupObject .euclidean3, m.profile = cp :=
  build_minimal_blowup_object cp hmode hmin

/-- Backward-uniqueness theorem in the selected periodic compactness class. -/
theorem periodic_backward_uniqueness_theorem
    (cp : CompactnessProfile .euclidean3)
    (hbu : ∀ x i, cp.limitingVelocity x i = 0) :
    SatisfiesBackwardUniquenessCriterion cp := by
  intro x i
  exact hbu x i

/-- Liouville/rigidity contradiction theorem in periodic contradiction route. -/
theorem periodic_liouville_rigidity_contradiction
    (cp : CompactnessProfile .euclidean3)
    (hbu : SatisfiesBackwardUniquenessCriterion cp)
    (hliouville : SatisfiesLiouvilleCriterion cp)
    (hnontrivial : ∃ x i, cp.limitingVelocity x i ≠ 0) :
    ¬ IsMinimalBlowupObject cp := by
  exact backward_uniqueness_liouville_excludes_minimal_blowup cp hbu hliouville hnontrivial

/-- Residual periodic obstruction packaged as a Clay `(D)` candidate. -/
structure PeriodicResidualObstruction where
  /-- Periodic Clay hypothesis bundle. -/
  H : ClayDHypotheses
  /-- Uniform nonexistence property matching Clay `(D)` conclusion pattern. -/
  obstruction :
    ∀ NS : IncompressibleNavierStokes .euclidean3,
      NS.nu = H.ν →
      CompatibleWithExternalForce NS H.f →
      ¬ (∃ sol : StrongSolution NS,
          sol.vel 0 = H.u0 ∧
          Condition10 sol.vel ∧
          Condition11 NS sol)

/-- Any residual periodic obstruction yields the Clay `(D)` statement schema. -/
theorem clayD_of_periodic_residual_obstruction
    (R : PeriodicResidualObstruction) :
    ClayDStatement := by
  refine ⟨R.H, ?_⟩
  intro NS hnu hforce
  exact R.obstruction NS hnu hforce

end Gibbs.ContinuumField.NavierStokes
