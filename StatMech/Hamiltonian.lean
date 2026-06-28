import StatMech.Hamiltonian.Basic
import StatMech.Hamiltonian.ConvexHamiltonian
import StatMech.Hamiltonian.DampedFlow
import StatMech.Hamiltonian.Ergodic
import StatMech.Hamiltonian.FenchelMoreau
import StatMech.Hamiltonian.GaussianIntegrals
import StatMech.Hamiltonian.GeneralHamiltonian
import StatMech.Hamiltonian.Legendre
import StatMech.Hamiltonian.PartitionFunction
import StatMech.Hamiltonian.Entropy
import StatMech.Hamiltonian.EntropyBregman
import StatMech.Hamiltonian.Channel
import StatMech.Hamiltonian.ChannelSession
import StatMech.Hamiltonian.Coding
import StatMech.Axioms
import StatMech.Hamiltonian.EnergyDistance
import StatMech.Hamiltonian.EnergyGap
import StatMech.Hamiltonian.NoseHoover
import StatMech.Hamiltonian.SymplecticFlow
import StatMech.Hamiltonian.Stochastic
import StatMech.Hamiltonian.Choreography
import StatMech.Hamiltonian.GlobalType
import StatMech.Hamiltonian.Stability
import StatMech.Hamiltonian.Examples.HarmonicOscillator
import StatMech.Hamiltonian.Examples.Langevin
import StatMech.Hamiltonian.Examples.ThermostatOscillator
import StatMech.Hamiltonian.Examples.GradientDescent
import StatMech.Hamiltonian.Examples.GradientDescentMinimizer
import StatMech.Hamiltonian.Examples.HeavyBallConvergence
import StatMech.Hamiltonian.Examples.LatticeMaxwell

/-! # Hamiltonian Layer

Single entry point for the Hamiltonian mechanics layer. Importing this file
brings in phase space foundations, convex and general Hamiltonians, damped and
symplectic dynamics, Legendre/Fenchel-Moreau duality, Lyapunov stability,
Gibbs measures, entropy/KL divergence, channel capacity bridges, the
Nose-Hoover thermostat, stochastic Langevin dynamics, choreography, and all
worked examples.
-/
