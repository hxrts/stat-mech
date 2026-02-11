import Gibbs.ContinuumField.NavierStokes.Linear.DuhamelFixedPoint
import Gibbs.ContinuumField.NavierStokes.Functional.ConcretePeriodic
import Gibbs.ContinuumField.NavierStokes.Defect.Continuation

/-! # Constructive local theory on the periodic target

Concrete periodic `(B)`-setting wrappers for Duhamel fixed-point local theory,
with explicit small-time contraction data and continuation criteria.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Trajectory norms and balls -/

/-- Concrete trajectory norm proxy for periodic local theory. -/
def periodicTrajectoryNorm (U : VelocityTrajectory .torus3) : ℝ :=
  periodicVelocityControlNorm (U 0)

/-- Nonnegativity of the concrete periodic trajectory norm. -/
theorem periodicTrajectoryNorm_nonneg (U : VelocityTrajectory .torus3) :
    0 ≤ periodicTrajectoryNorm U := by
  exact periodicVelocityControlNorm_nonneg (U 0)

/-- Closed ball predicate in the concrete periodic trajectory norm. -/
def InPeriodicTrajectoryBall
    (center : VelocityTrajectory .torus3)
    (radius : ℝ)
    (U : VelocityTrajectory .torus3) : Prop :=
  periodicTrajectoryNorm (fun t => U t - center t) ≤ radius

/-- Concrete periodic Duhamel map used in the `(B)` local fixed-point step. -/
def periodicDuhamelMap
    (S : StokesSemigroup .torus3)
    (NS : IncompressibleNavierStokes .torus3)
    (u0 : VelocityField .torus3) :
    VelocityTrajectory .torus3 → VelocityTrajectory .torus3 :=
  fun U t => S.apply t u0 + (NS.forcing - NS.ops.convection (U t))

/-- Explicit small-time condition for contraction on a trajectory ball. -/
def SmallTimeContractionCondition (T L : ℝ) : Prop :=
  0 < T ∧ 0 ≤ L ∧ L < 1

/-! ## Contraction data and theorem -/

/-- Contraction data for periodic Duhamel fixed-point construction. -/
structure PeriodicContractionWitness
    (S : StokesSemigroup .torus3)
    (NS : IncompressibleNavierStokes .torus3)
    (u0 : VelocityField .torus3) where
  /-- Local time horizon. -/
  T : ℝ
  /-- Ball center. -/
  center : VelocityTrajectory .torus3
  /-- Ball radius. -/
  radius : ℝ
  radius_nonneg : 0 ≤ radius
  /-- Contraction constant. -/
  L : ℝ
  /-- Explicit small-time hypothesis. -/
  smallness : SmallTimeContractionCondition T L
  /-- Ball invariance under the Duhamel map. -/
  maps_ball :
    ∀ U, InPeriodicTrajectoryBall center radius U →
      InPeriodicTrajectoryBall center radius (periodicDuhamelMap S NS u0 U)
  /-- Contraction estimate in the concrete trajectory norm. -/
  contractive :
    ∀ U V,
      InPeriodicTrajectoryBall center radius U →
      InPeriodicTrajectoryBall center radius V →
      periodicTrajectoryNorm
        (fun t => periodicDuhamelMap S NS u0 U t - periodicDuhamelMap S NS u0 V t) ≤
        L * periodicTrajectoryNorm (fun t => U t - V t)

/-- Contraction theorem on a small-time trajectory ball (explicit hypotheses). -/
theorem periodic_duhamel_contraction_on_ball
    (S : StokesSemigroup .torus3)
    (NS : IncompressibleNavierStokes .torus3)
    (u0 : VelocityField .torus3)
    (W : PeriodicContractionWitness S NS u0) :
    SmallTimeContractionCondition W.T W.L ∧
      (∀ U, InPeriodicTrajectoryBall W.center W.radius U →
        InPeriodicTrajectoryBall W.center W.radius (periodicDuhamelMap S NS u0 U)) ∧
      (∀ U V,
        InPeriodicTrajectoryBall W.center W.radius U →
        InPeriodicTrajectoryBall W.center W.radius V →
        periodicTrajectoryNorm
          (fun t => periodicDuhamelMap S NS u0 U t - periodicDuhamelMap S NS u0 V t) ≤
          W.L * periodicTrajectoryNorm (fun t => U t - V t)) := by
  exact ⟨W.smallness, W.maps_ball, W.contractive⟩

/-! ## Local solution construction -/

/-- Constructive periodic local strong solution carrying explicit fixed-point data. -/
structure ConstructivePeriodicLocalSolution
    (S : StokesSemigroup .torus3)
    (NS : IncompressibleNavierStokes .torus3)
    (u0 : VelocityField .torus3) where
  /-- Local horizon. -/
  T : ℝ
  T_pos : 0 < T
  /-- Solution trajectories. -/
  vel : VelocityTrajectory .torus3
  press : PressureTrajectory .torus3
  dvel : VelocityTrajectory .torus3
  /-- Strong-solution side conditions. -/
  smooth_vel : ∀ t, IsSmoothField NS (vel t)
  smooth_press : ∀ t, IsSmoothPressure NS (press t)
  solves : ∀ t, SolvesNavierStokes NS (vel t) (press t) (dvel t)
  /-- Initial condition and fixed-point identity. -/
  initial_value : vel 0 = u0
  fixed_point : periodicDuhamelMap S NS u0 vel = vel

/-- Any constructive periodic local solution yields a strong-solution object. -/
def ConstructivePeriodicLocalSolution.toStrong
    {S : StokesSemigroup .torus3}
    {NS : IncompressibleNavierStokes .torus3}
    {u0 : VelocityField .torus3}
    (C : ConstructivePeriodicLocalSolution S NS u0) :
    StrongSolution NS where
  vel := C.vel
  press := C.press
  dvel := C.dvel
  smooth_vel := C.smooth_vel
  smooth_press := C.smooth_press
  solves := C.solves

/-- Constructive local existence + uniqueness theorem in periodic fixed-point form. -/
theorem periodic_constructive_local_existence_uniqueness
    (S : StokesSemigroup .torus3)
    (NS : IncompressibleNavierStokes .torus3)
    (u0 : VelocityField .torus3)
    (center : VelocityTrajectory .torus3)
    (radius : ℝ)
    (C : ConstructivePeriodicLocalSolution S NS u0)
    (hunique :
      ∀ v,
        InPeriodicTrajectoryBall center radius v →
        periodicDuhamelMap S NS u0 v = v →
        v 0 = u0 →
        v = C.vel) :
    ∃ sol : StrongSolution NS,
      sol.vel 0 = u0 ∧
      periodicDuhamelMap S NS u0 sol.vel = sol.vel ∧
      (∀ v,
        InPeriodicTrajectoryBall center radius v →
        periodicDuhamelMap S NS u0 v = v →
        v 0 = u0 →
        v = sol.vel) := by
  refine ⟨C.toStrong, C.initial_value, C.fixed_point, ?_⟩
  intro v hv hfp hv0
  exact hunique v hv hfp hv0

/-! ## Continuation criteria -/

/-- Concrete periodic critical norm object for continuation statements. -/
def periodicContinuationCriticalNorm : CriticalNorm .torus3 where
  target := .L3
  value := periodicCriticalNorm
  nonneg := periodicCriticalNorm_nonneg

/-- Continuation criterion in the same concrete periodic space as local theory. -/
theorem periodic_continuation_criterion
    (NS : IncompressibleNavierStokes .torus3)
    (sol : StrongSolution NS)
    (T budget : ℝ)
    (hbound : ∀ t, 0 ≤ t → t ≤ T → periodicCriticalNorm (sol.vel t) ≤ budget) :
    NoBlowupUpTo NS periodicContinuationCriticalNorm sol T budget := by
  intro t ht0 htT
  exact hbound t ht0 htT

/-- Blow-up alternative form driven by the periodic continuation criterion. -/
def PeriodicBlowupAlternative
    (NS : IncompressibleNavierStokes .torus3)
    (sol : StrongSolution NS)
    (T budget : ℝ) : Prop :=
  NoBlowupUpTo NS periodicContinuationCriticalNorm sol T budget ∨
    (∀ M : ℝ, ∃ t, 0 ≤ t ∧ t ≤ T ∧ M ≤ periodicCriticalNorm (sol.vel t))

/-- If the continuation bound holds, the no-blowup branch of the alternative is realized. -/
theorem periodic_blowup_alternative_of_continuation
    (NS : IncompressibleNavierStokes .torus3)
    (sol : StrongSolution NS)
    (T budget : ℝ)
    (hbound : ∀ t, 0 ≤ t → t ≤ T → periodicCriticalNorm (sol.vel t) ≤ budget) :
    PeriodicBlowupAlternative NS sol T budget := by
  left
  exact periodic_continuation_criterion NS sol T budget hbound

end Gibbs.ContinuumField.NavierStokes
