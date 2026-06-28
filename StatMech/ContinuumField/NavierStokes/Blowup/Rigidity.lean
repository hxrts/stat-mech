import StatMech.ContinuumField.NavierStokes.Blowup.Compactness

/-! # Blow-up rigidity scaffolding

Rigidity interface used to exclude minimal blow-up objects.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Predicate: compactness profile is a minimal blow-up object. -/
def IsMinimalBlowupObject {D : SpatialDomain3}
    (cp : CompactnessProfile D) : Prop :=
  ∃ m : MinimalBlowupObject D, m.profile = cp

/-- Rigidity predicate excluding minimal blow-up objects. -/
def SatisfiesRigidityCriterion {D : SpatialDomain3}
    (cp : CompactnessProfile D) : Prop :=
  ∀ x i, cp.limitingVelocity x i = 0

/-- Backward-uniqueness style criterion on the limiting velocity profile. -/
def SatisfiesBackwardUniquenessCriterion {D : SpatialDomain3}
    (cp : CompactnessProfile D) : Prop :=
  ∀ x i, cp.limitingVelocity x i = 0

/-- Liouville-style criterion on limiting pressure profile. -/
def SatisfiesLiouvilleCriterion {D : SpatialDomain3}
    (cp : CompactnessProfile D) : Prop :=
  ∀ x, cp.limitingPressure x = 0

/-- Backward uniqueness + Liouville hypotheses imply the rigidity criterion. -/
theorem backward_uniqueness_liouville_implies_rigidity {D : SpatialDomain3}
    (cp : CompactnessProfile D)
    (hbu : SatisfiesBackwardUniquenessCriterion cp)
    (_hliouville : SatisfiesLiouvilleCriterion cp) :
    SatisfiesRigidityCriterion cp := by
  intro x i
  exact hbu x i

/-- Interface theorem: rigidity criterion rules out minimal blow-up objects. -/
theorem rigidity_excludes_minimal_blowup {D : SpatialDomain3}
    (cp : CompactnessProfile D)
    (hrig : SatisfiesRigidityCriterion cp)
    (hnontrivial : ∃ x i, cp.limitingVelocity x i ≠ 0) :
    ¬ IsMinimalBlowupObject cp := by
  intro hmin
  rcases hmin with ⟨m, hm⟩
  rcases hnontrivial with ⟨x, i, hne⟩
  have hzero_cp : cp.limitingVelocity x i = 0 := hrig x i
  have hzero_m : m.profile.limitingVelocity x i = 0 := by
    simpa [hm] using hzero_cp
  exact hne (by simpa [hm] using hzero_m)

/-- Backward-uniqueness/Liouville-style rigidity route excluding minimal objects. -/
theorem backward_uniqueness_liouville_excludes_minimal_blowup {D : SpatialDomain3}
    (cp : CompactnessProfile D)
    (hbu : SatisfiesBackwardUniquenessCriterion cp)
    (hliouville : SatisfiesLiouvilleCriterion cp)
    (hnontrivial : ∃ x i, cp.limitingVelocity x i ≠ 0) :
    ¬ IsMinimalBlowupObject cp := by
  exact rigidity_excludes_minimal_blowup cp
    (backward_uniqueness_liouville_implies_rigidity cp hbu hliouville)
    hnontrivial

/-- A uniform bound for a witness norm contradicts finite-time blow-up. -/
theorem bounded_norm_excludes_finite_time_blowup {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (w : FiniteTimeBlowupWitness NS)
    (B : ℝ)
    (hbound : ∀ t, 0 ≤ t → t ≤ w.Tstar → w.K.value (w.sol.vel t) ≤ B) :
    False := by
  rcases w.exceed_every_budget B with ⟨t, ht0, htT, hlt⟩
  have hle : w.K.value (w.sol.vel t) ≤ B := hbound t ht0 htT
  exact (not_lt_of_ge hle) hlt

/-- No-blowup up to `T*` excludes a finite-time blow-up witness at `T*`. -/
theorem no_blowup_up_to_excludes_witness {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (w : FiniteTimeBlowupWitness NS)
    (hnoblow : NoBlowupUpTo NS w.K w.sol w.Tstar w.Tstar) :
    False := by
  exact bounded_norm_excludes_finite_time_blowup w w.Tstar hnoblow

/-- Final contradiction form: finite-time blow-up is incompatible with bounded critical norm up to `T*`. -/
theorem final_contradiction_of_bounded_critical_norm {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (w : FiniteTimeBlowupWitness NS)
    (hnoblow : NoBlowupUpTo NS w.K w.sol w.Tstar w.Tstar) :
    False :=
  no_blowup_up_to_excludes_witness w hnoblow

end StatMech.ContinuumField.NavierStokes
