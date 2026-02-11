import Gibbs.Hamiltonian.Basic
import Gibbs.Hamiltonian.ConvexHamiltonian
import Gibbs.Hamiltonian.DampedFlow

/-! # Heavy-Ball Method as Damped Hamiltonian

The heavy-ball (momentum) method for minimizing a convex objective V(q) is
exactly the damped Hamiltonian system with H(q,p) = (1/2) norm(p)^2 + V(q).
Momentum provides inertia that accelerates convergence past narrow valleys,
while damping ensures eventual dissipation to the minimum.

This file packages a convex differentiable potential into a `ConvexHamiltonian`
and defines the heavy-ball drift as the corresponding damped Hamiltonian drift.
-/

namespace Gibbs.Hamiltonian.Examples

noncomputable section

/-! ## Momentum Hamiltonian -/

/-- Gradient flow for an objective: q̇ = -∇V(q). -/
noncomputable def gradientFlow (n : ℕ) (V : Config n → ℝ) : Config n → Config n := by
  -- Use the negative gradient direction.
  exact fun q => -gradient V q

/-- Hamiltonian for a convex objective with quadratic kinetic energy. -/
noncomputable def momentumHamiltonian (n : ℕ) (V : Config n → ℝ)
    (hVconv : ConvexOn ℝ Set.univ V) (hVdiff : Differentiable ℝ V) :
    ConvexHamiltonian n := by
  -- Combine quadratic kinetic energy with the given potential.
  exact
    { T := quadraticKinetic n
      V := V
      T_convex := quadraticKinetic_convex n
      V_convex := hVconv
      T_diff := quadraticKinetic_diff n
      V_diff := hVdiff }

/-! ## Heavy-Ball Drift -/

/-- Heavy-ball (momentum) method as a damped Hamiltonian drift. -/
noncomputable def heavyBallDrift (n : ℕ) (V : Config n → ℝ)
    (hVconv : ConvexOn ℝ Set.univ V) (hVdiff : Differentiable ℝ V)
    (d : Damping) : PhasePoint n → PhasePoint n := by
  -- Apply the damped drift to the momentum Hamiltonian.
  exact dampedDrift (momentumHamiltonian n V hVconv hVdiff) d

/-! ## Comparison with Gradient Flow -/

/-- If momentum equals the negative gradient, the q-dynamics match gradient flow. -/
theorem heavyBall_q_equals_gradientFlow (n : ℕ) (V : Config n → ℝ)
    (hVconv : ConvexOn ℝ Set.univ V) (hVdiff : Differentiable ℝ V)
    (d : Damping) (x : PhasePoint n)
    (hp : x.p = -gradient V x.q) :
    (heavyBallDrift n V hVconv hVdiff d x).q = gradientFlow n V x.q := by
  -- Expand the q-component and use ∇(½‖·‖²) = id.
  simp [heavyBallDrift, dampedDrift_q, momentumHamiltonian, gradientFlow,
    ConvexHamiltonian.velocity, quadraticKinetic_grad, hp]

/-! ## Heavy-Ball Lyapunov Candidate -/

/-- Heavy-ball Lyapunov candidate around a reference point. -/
noncomputable def heavyBallLyapunov (n : ℕ) (f : Config n → ℝ)
    (x_star : Config n) (ε : ℝ) (x : PhasePoint n) : ℝ :=
  (f x.q - f x_star) + (1 / 2) * ‖x.p‖ ^ 2 +
    ε * inner (𝕜 := ℝ) (x.q - x_star) x.p

/-- Strong convexity gives a quadratic lower bound at a stationary point. -/
theorem strongConvex_bound_f (f : Config n → ℝ) (m : ℝ)
    (hf : StronglyConvex (n := n) f m) (x_star : Config n)
    (h_grad : gradient f x_star = 0) (x : Config n) :
    f x ≥ f x_star + (m / 2) * ‖x - x_star‖ ^ 2 := by
  have h := hf.lower_bound x_star x
  simpa [h_grad] using h

/-- Lipschitz gradient gives a bound on ‖∇f(x)‖ around a stationary point. -/
theorem lipschitz_bound_gradient (f : Config n → ℝ) (L : ℝ)
    (hf : LipschitzGradient (n := n) f L) (x_star : Config n)
    (h_grad : gradient f x_star = 0) (x : Config n) :
    ‖gradient f x‖ ≤ L * ‖x - x_star‖ := by
  have h := hf.lipschitz x x_star
  simpa [h_grad] using h

/-- Lipschitz gradient bounds the inner product with the displacement. -/
theorem lipschitz_bound_inner (f : Config n → ℝ) (L : ℝ)
    (hf : LipschitzGradient (n := n) f L) (x_star : Config n)
    (h_grad : gradient f x_star = 0) (x : Config n) :
    inner (𝕜 := ℝ) (x - x_star) (gradient f x) ≤ L * ‖x - x_star‖ ^ 2 := by
  have hcs :
      inner (𝕜 := ℝ) (x - x_star) (gradient f x) ≤
        ‖x - x_star‖ * ‖gradient f x‖ := by
    exact (le_trans (le_abs_self _) (abs_real_inner_le_norm _ _))
  have hgrad := lipschitz_bound_gradient (n := n) f L hf x_star h_grad x
  have hmul :
      ‖x - x_star‖ * ‖gradient f x‖ ≤ ‖x - x_star‖ * (L * ‖x - x_star‖) := by
    exact mul_le_mul_of_nonneg_left hgrad (norm_nonneg _)
  calc
    inner (𝕜 := ℝ) (x - x_star) (gradient f x)
        ≤ ‖x - x_star‖ * ‖gradient f x‖ := hcs
    _ ≤ ‖x - x_star‖ * (L * ‖x - x_star‖) := hmul
    _ = L * ‖x - x_star‖ ^ 2 := by
          ring

end

end Gibbs.Hamiltonian.Examples
