import StatMech.ContinuumField.NavierStokes.Global.NoBlowup
import StatMech.ContinuumField.NavierStokes.ClaySpec

/-! # Clay-periodic global closure route

Periodic `(B)`-target wrappers connecting invariant packages, global envelope
control, critical-norm no-blowup bounds, and Clay statement instantiation.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Invariant package specialized to the periodic Clay target setting. -/
structure PeriodicInvariantPackage
    (NS : IncompressibleNavierStokes .euclidean3) where
  /-- Underlying invariant-envelope system. -/
  system : InvariantEnvelopeSystem NS
  /-- Critical target aligned with periodic Clay route (`L^3` first pass). -/
  critical_target : system.envelope.criticalNorm.target = .L3

/-- Invariant package implies global envelope boundedness. -/
theorem periodic_invariant_implies_global_envelope_bounded
    {NS : IncompressibleNavierStokes .euclidean3}
    (P : PeriodicInvariantPackage NS) :
    IsGloballyBoundedEnvelope P.system.envelope := by
  exact closure_of_invariant_system P.system

/-- Global envelope boundedness yields a global critical-norm no-blowup bound. -/
theorem periodic_global_critical_bound_of_envelope
    {NS : IncompressibleNavierStokes .euclidean3}
    (P : PeriodicInvariantPackage NS) :
    ∀ T, 0 ≤ T →
      NoBlowupUpTo NS P.system.envelope.criticalNorm P.system.sol T
        P.system.envelope.criticalBudget := by
  intro T hT
  exact continuation_of_defect_envelope NS P.system.envelope P.system.sol T hT
    (periodic_invariant_implies_global_envelope_bounded P) P.system.critical_match

/-- Data sufficient to instantiate one concrete `(B)` statement instance. -/
structure ClayBRegularityData (H : ClayBHypotheses) where
  /-- NSE model for the instance. -/
  NS : IncompressibleNavierStokes .euclidean3
  /-- Parameter/data matching to Clay hypotheses. -/
  nu_match : NS.nu = H.ν
  forcing_zero : NS.forcing = 0
  /-- Invariant closure package and resulting strong solution. -/
  periodicPackage : PeriodicInvariantPackage NS
  init_match : periodicPackage.system.sol.vel 0 = H.u0
  /-- Clay regularity clauses for `(B)`. -/
  periodicity : Condition10 periodicPackage.system.sol.vel
  smoothness : Condition11 NS periodicPackage.system.sol

/-- One periodic regularity data package yields one `(B)` theorem instance. -/
theorem clayB_instance_of_regularity_data
    (H : ClayBHypotheses)
    (R : ClayBRegularityData H) :
    ∃ NS : IncompressibleNavierStokes .euclidean3,
      NS.nu = H.ν ∧
      NS.forcing = 0 ∧
      ∃ sol : StrongSolution NS,
        sol.vel 0 = H.u0 ∧
        Condition10 sol.vel ∧
        Condition11 NS sol := by
  refine ⟨R.NS, R.nu_match, R.forcing_zero, ?_⟩
  refine ⟨R.periodicPackage.system.sol, R.init_match, R.periodicity, ?_⟩
  exact R.smoothness

/-- Family of periodic regularity data packages yields the full Clay `(B)` schema. -/
theorem clayBStatement_of_regularity_data_family
    (hfamily : ∀ H : ClayBHypotheses, ClayBRegularityData H) :
    ClayBStatement := by
  intro H
  exact clayB_instance_of_regularity_data H (hfamily H)

end StatMech.ContinuumField.NavierStokes
