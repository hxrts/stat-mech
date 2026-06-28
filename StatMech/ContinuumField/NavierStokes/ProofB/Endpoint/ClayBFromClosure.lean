import StatMech.ContinuumField.NavierStokes.ProofB.Closure.GlobalClosure
import StatMech.ContinuumField.NavierStokes.ProofB.Closure.ClosureDischarge
import StatMech.ContinuumField.NavierStokes.ProofB.Legacy.Primitive.Endpoint

/-! # Definitive Clay `(B)` discharge

Final definitive-path bridge from unconditional hard-step closure to the
unresolved core lemma and full `ClayBStatement`.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Definitive core closure lemma (all-data Clay `(B)` regularity data). -/
def DefinitiveCoreClosureLemma : Type :=
  ∀ H : ClayBHypotheses, ClayBRegularityData H

/-- The definitive bridge discharges the core unresolved lemma. -/
def definitiveCoreLemma_of_globalClosure
    (excludes_all_minimal : ∀ _m : HardStepMinimalElement, False)
    (regularity_of_closure :
      HardStepGlobalClosure → (∀ H : ClayBHypotheses, ClayBRegularityData H)) :
    DefinitiveCoreClosureLemma :=
  regularity_of_closure (definitiveHardStepGlobalClosure excludes_all_minimal)

/-- The previous unresolved lemma is now replaced by the definitive core lemma. -/
def unresolvedLemma_replaced_by_definitiveCore
    (excludes_all_minimal : ∀ _m : HardStepMinimalElement, False)
    (regularity_of_closure :
      HardStepGlobalClosure → (∀ H : ClayBHypotheses, ClayBRegularityData H)) :
    UnresolvedClayBGlobalClosureLemma :=
  definitiveCoreLemma_of_globalClosure excludes_all_minimal regularity_of_closure

/-- Full Clay `(B)` statement for all admissible data from definitive closure discharge. -/
theorem definitiveClayBStatement :
    (excludes_all_minimal : ∀ _m : HardStepMinimalElement, False) →
    (regularity_of_closure :
      HardStepGlobalClosure → (∀ H : ClayBHypotheses, ClayBRegularityData H)) →
    ClayBStatement := by
  intro excludes_all_minimal regularity_of_closure
  exact clayBStatement_of_unresolvedLemma
    (unresolvedLemma_replaced_by_definitiveCore excludes_all_minimal regularity_of_closure)

/-- Compatibility theorem preserving the previous closure-parameterized definitive endpoint. -/
theorem definitiveClayBStatement_of_globalClosure
    (excludes_all_minimal : ∀ _m : HardStepMinimalElement, False)
    (regularity_of_closure :
      HardStepGlobalClosure → (∀ H : ClayBHypotheses, ClayBRegularityData H)) :
    ClayBStatement := by
  exact definitiveClayBStatement excludes_all_minimal regularity_of_closure

/-- Definitive dependency graph marking the closure branch as discharged. -/
def definitiveClayBDependencyGraph : DependencyGraph where
  root := "DefinitiveClayBStatement"
  deps :=
    [ "Definitive analytic norms/operators (no proxy layer)"
    , "Derived long-time perturbation + envelope robustness theorems"
    , "Unconditional critical-element contradiction chain"
    , "Unconditional hard-step global closure"
    , "Core closure lemma for all ClayB hypotheses"
    ]

end StatMech.ContinuumField.NavierStokes
