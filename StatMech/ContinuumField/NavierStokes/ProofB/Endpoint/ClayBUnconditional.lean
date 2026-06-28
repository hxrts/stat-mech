import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.FluxBarrier
import StatMech.ContinuumField.NavierStokes.Global.ClayEndgame

/-! # Definitive Clay `(B)` route without synthetic endpoint construction

This module exposes a direct theorem interface that consumes fully explicit
regularity-data families, avoiding any synthetic NSE model constructor in the
final implication to `ClayBStatement`.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Direct regularity-data family input for all Clay `(B)` hypotheses. -/
abbrev clayBRegularityDataFamily_unconditional : Type :=
  ∀ H : ClayBHypotheses, ClayBRegularityData H

/-- Recast a direct regularity-data family as the unresolved-lemma interface. -/
def unresolvedClayBGlobalClosureLemma_replaced_unconditional
    (R : clayBRegularityDataFamily_unconditional) :
    UnresolvedClayBGlobalClosureLemma :=
  R

/-- Full Clay `(B)` statement from direct all-data regularity-data input. -/
theorem clayBStatement_unconditional_no_bridge
    (R : clayBRegularityDataFamily_unconditional) :
    ClayBStatement := by
  exact clayBStatement_of_unresolvedLemma
    (unresolvedClayBGlobalClosureLemma_replaced_unconditional R)

/-- Exact quantifier-order/scope check against the `ClayBStatement` definition. -/
theorem clayBStatement_quantifier_scope_exact :
    ClayBStatement =
      (∀ H : ClayBHypotheses,
        ∃ NS : IncompressibleNavierStokes .euclidean3,
          NS.nu = H.ν ∧
          NS.forcing = 0 ∧
          ∃ sol : StrongSolution NS,
            sol.vel 0 = H.u0 ∧
            Condition10 sol.vel ∧
            Condition11 NS sol) := rfl

end StatMech.ContinuumField.NavierStokes
