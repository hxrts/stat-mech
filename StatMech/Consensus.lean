import StatMech.Consensus.Basic
import StatMech.Consensus.Observation
import StatMech.Consensus.Decision
import StatMech.Consensus.Adversary
import StatMech.Consensus.TranscriptDistance
import StatMech.Consensus.InteractiveDistance
import StatMech.Consensus.PartitionFunction
import StatMech.Consensus.OrderParameter
import StatMech.Consensus.Gap
import StatMech.Consensus.Quorum
import StatMech.Consensus.Thresholds
import StatMech.Consensus.UniversalityClasses
import StatMech.Consensus.CodingBridge
import StatMech.Consensus.CodingDistance
import StatMech.Consensus.Certificates
import StatMech.Consensus.Hamiltonian
import StatMech.Consensus.SafetyLiveness
import StatMech.Consensus.ChannelThreshold
import StatMech.Consensus.Examples.RepetitionCode
import StatMech.Consensus.Examples.QuorumBFT
import StatMech.Consensus.Examples.NakamotoSketch

/-! # Consensus layer facade

Single entry point for the consensus-as-statistical-mechanics framework.
Importing this file brings in the full stack: execution model, observation
and decision maps, adversary model, transcript and interactive distances,
partition functions, energy gaps, quorum systems, Byzantine thresholds,
universality classes, the coding-theory bridge, and worked examples
(repetition code, quorum BFT, Nakamoto sketch), plus channel-capacity
thresholds.
-/
