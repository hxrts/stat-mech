import StatMech.MeanField.Examples.Ising.TanhAnalysis
import StatMech.MeanField.Examples.Ising.Drift
import StatMech.MeanField.Examples.Ising.Glauber
import StatMech.MeanField.Examples.Ising.PhaseTransition

/-! # Ising Model

Facade for the mean-field Ising example. Imports the tanh analysis needed for
Lipschitz bounds, the Ising drift and choreography, Glauber dynamics (local
transition rates that reproduce the global drift), and the phase transition
proof (unique paramagnetic equilibrium for beta J < 1, bistability for
beta J > 1).
-/
