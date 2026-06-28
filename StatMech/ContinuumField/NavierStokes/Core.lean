import StatMech.ContinuumField.Projection

/-! # Continuum-field Navier-Stokes representation

This module gives a structural encoding of incompressible Navier-Stokes in
the continuum-field layer. We reuse `FieldState` as

- `rho(x)` for density,
- `p(x)` for velocity,
- `omega(x)` for pressure.

The representation is intentionally operator-parametric: gradient, divergence,
Laplacian, and advection are bundled abstractly so the same interface works
for finite-volume, spectral, or kernelized discretizations.
-/

namespace StatMech.ContinuumField

open scoped Classical

/-! ## State View -/

/-- Incompressible Navier-Stokes state encoded in the generic field bundle. -/
abbrev NavierStokesState (X : Type*) (V : Type*) := FieldState X V ℝ

namespace NavierStokesState

/-- Density field `rho(x)`. -/
def density {X V : Type*} (s : NavierStokesState X V) : Field X ℝ :=
  s.rho

/-- Velocity field `u(x)`. -/
def velocity {X V : Type*} (s : NavierStokesState X V) : Field X V :=
  s.p

/-- Pressure field `pi(x)`. -/
def pressure {X V : Type*} (s : NavierStokesState X V) : Field X ℝ :=
  s.omega

end NavierStokesState

/-! ## Local PDE Operators -/

/-- Differential operators needed by incompressible Navier-Stokes. -/
structure NavierStokesOps (X : Type*) (V : Type*) where
  /-- Pressure gradient `grad pi`. -/
  grad : Field X ℝ → Field X V
  /-- Velocity divergence `div u`. -/
  div : Field X V → Field X ℝ
  /-- Vector Laplacian `Delta u`. -/
  laplace : Field X V → Field X V
  /-- Convective term `(u · nabla) u`. -/
  advection : Field X V → Field X V

section LocalModel

variable {X V : Type*}

/-- Parametric incompressible Navier-Stokes model with constant viscosity. -/
structure NavierStokesModel (X : Type*) (V : Type*) where
  /-- Differential operators used by the PDE. -/
  ops : NavierStokesOps X V
  /-- Kinematic viscosity coefficient. -/
  nu : ℝ
  /-- Physical viscosity is nonnegative. -/
  nu_nonneg : 0 ≤ nu
  /-- External forcing term `f(x)`. -/
  forcing : Field X V

/-- RHS of `du/dt + (u·nabla)u = -grad pi + nu Delta u + f`. -/
def momentumRHS [AddCommGroup V] [Module ℝ V] (M : NavierStokesModel X V)
    (s : NavierStokesState X V) : Field X V :=
  -(M.ops.advection (NavierStokesState.velocity s))
    - M.ops.grad (NavierStokesState.pressure s)
    + M.nu • M.ops.laplace (NavierStokesState.velocity s)
    + M.forcing

/-- Residual form of the momentum equation. -/
def momentumResidual [AddCommGroup V] [Module ℝ V] (M : NavierStokesModel X V)
    (s : NavierStokesState X V) (du_dt : Field X V) : Field X V :=
  du_dt - momentumRHS M s

/-- Residual form of incompressibility (`div u = 0`). -/
def incompressibilityResidual (M : NavierStokesModel X V)
    (s : NavierStokesState X V) : Field X ℝ :=
  M.ops.div (NavierStokesState.velocity s)

/-- Momentum equation satisfaction (`momentumResidual = 0`). -/
def SatisfiesMomentumEq [AddCommGroup V] [Module ℝ V] (M : NavierStokesModel X V)
    (s : NavierStokesState X V) (du_dt : Field X V) : Prop :=
  momentumResidual M s du_dt = 0

/-- Incompressibility satisfaction (`div u = 0`). -/
def IsIncompressible (M : NavierStokesModel X V)
    (s : NavierStokesState X V) : Prop :=
  incompressibilityResidual M s = 0

/-- Full incompressible Navier-Stokes predicate. -/
def IsIncompressibleNavierStokes [AddCommGroup V] [Module ℝ V] (M : NavierStokesModel X V)
    (s : NavierStokesState X V) (du_dt : Field X V) : Prop :=
  SatisfiesMomentumEq M s du_dt ∧ IsIncompressible M s

/-- Unfolded incompressibility criterion. -/
theorem isIncompressible_iff
    (M : NavierStokesModel X V) (s : NavierStokesState X V) :
    IsIncompressible M s ↔ M.ops.div (NavierStokesState.velocity s) = 0 := by
  rfl

end LocalModel

section KernelModel

variable {X V : Type*}
variable [MeasureTheory.MeasureSpace X] [Add X]
variable [NormedAddCommGroup V] [NormedSpace ℝ V]

/-- Kernel-induced nonlocal diffusion operator wrapper. -/
def nonlocalDiffusion (diffusion : Field X V → Field X V) (u : Field X V) : Field X V :=
  diffusion u

/-- The canonical local and global nonlocal operators coincide pointwise. -/
theorem nonlocalDiffusion_eq_global (K : GlobalKernel X) (u : Field X V) :
    nonlocalDiffusion (fun v x => nonlocalLocal K v x) u = fun x => nonlocalGlobal K u x := by
  funext x
  simpa [nonlocalDiffusion] using (nonlocal_exact K u x).symm

/-- Navier-Stokes model with an additional kernel diffusion channel. -/
structure KernelNavierStokesModel (X : Type*) (V : Type*)
    [MeasureTheory.MeasureSpace X] [Add X] [NormedAddCommGroup V] [NormedSpace ℝ V] where
  /-- Base local Navier-Stokes model. -/
  base : NavierStokesModel X V
  /-- Interaction kernel for nonlocal viscosity. -/
  K : GlobalKernel X
  /-- Chosen nonlocal diffusion operator (computable interface). -/
  diffusion : Field X V → Field X V
  /-- Semantic compatibility with the canonical kernel integral view. -/
  diffusion_eq_global : ∀ u : Field X V, diffusion u = fun x => nonlocalGlobal K u x
  /-- Strength of nonlocal diffusion. -/
  kappa : ℝ
  /-- Nonlocal diffusion coefficient is nonnegative. -/
  kappa_nonneg : 0 ≤ kappa

/-- Momentum RHS plus kernel-based diffusion correction. -/
def kernelMomentumRHS (M : KernelNavierStokesModel X V) (s : NavierStokesState X V) :
    Field X V :=
  momentumRHS M.base s
    + M.kappa • nonlocalDiffusion M.diffusion (NavierStokesState.velocity s)

/-- Residual form for the kernel-augmented momentum equation. -/
def kernelMomentumResidual (M : KernelNavierStokesModel X V) (s : NavierStokesState X V)
    (du_dt : Field X V) : Field X V :=
  du_dt - kernelMomentumRHS M s

/-- Predicate for the kernel-augmented momentum equation. -/
def SatisfiesKernelMomentumEq (M : KernelNavierStokesModel X V)
    (s : NavierStokesState X V) (du_dt : Field X V) : Prop :=
  kernelMomentumResidual M s du_dt = 0

/-- Full kernelized incompressible Navier-Stokes predicate. -/
def IsKernelNavierStokes (M : KernelNavierStokesModel X V)
    (s : NavierStokesState X V) (du_dt : Field X V) : Prop :=
  SatisfiesKernelMomentumEq M s du_dt ∧ IsIncompressible M.base s

/-- Rewrite kernel diffusion through the global nonlocal operator view. -/
theorem kernelMomentumRHS_eq_global (M : KernelNavierStokesModel X V)
    (s : NavierStokesState X V) :
    kernelMomentumRHS M s =
      momentumRHS M.base s
        + M.kappa • (fun x => nonlocalGlobal M.K (NavierStokesState.velocity s) x) := by
  simp [kernelMomentumRHS, nonlocalDiffusion, M.diffusion_eq_global]

end KernelModel

end StatMech.ContinuumField
