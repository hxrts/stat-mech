import StatMech.MeanField.Basic
import StatMech.MeanField.Rules
import StatMech.MeanField.Choreography
import StatMech.MeanField.GlobalType
import StatMech.MeanField.LipschitzBridge
import StatMech.MeanField.ODE
import StatMech.MeanField.Existence
import StatMech.MeanField.Stability
import StatMech.MeanField.Projection
import StatMech.MeanField.OrderParameter
import StatMech.MeanField.Universality
import StatMech.MeanField.BregmanBridge
import StatMech.MeanField.Examples.Ising

/-! # Mean-Field Layer

Single entry point for the mean-field layer. Importing this file brings in
simplex and population types, transition rules, choreography constraints,
the Lipschitz bridge to Mathlib ODE infrastructure, existence and stability
theorems, global-to-local projection, order parameters, universality classes,
and the Ising model example.
-/
