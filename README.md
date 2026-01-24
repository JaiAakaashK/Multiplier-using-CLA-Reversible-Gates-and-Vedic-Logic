Project Overview

  This project implements a Vedic multiplier architecture integrated with a Carry Look-Ahead Adder (CLA) designed using reversible logic gates. The goal is to combine:
  
  * High-speed multiplication using Vedic (Urdhva Tiryagbhyam) logic
  * Fast addition using Carry Look-Ahead Adder (CLA)
  * Low-power and information-preserving computation using reversible logic gates
  * A complete SystemVerilog verification environment for functional validation
  
  The design is suitable for academic research and coursework focused on:
  
  * Reversible computing
  * Low-power VLSI
  * High-speed arithmetic circuits
  * FPGA/ASIC-oriented digital design

Objectives
  
  * Implement Vedic multiplication for fast partial product generation
  * Implement Carry Look-Ahead Adder using reversible logic gates
  * Integrate reversible CLA into the multiplier datapath
  * Reduce carry propagation delay compared to ripple-carry adders
  * Demonstrate functional correctness using SystemVerilog verification
  * Avoid race conditions using cycle-accurate monitoring techniques

Architecture Summary

1. Vedic Multiplication (Urdhva Tiryagbhyam)

  The design is based on the Urdhva Tiryagbhyam (Vertical and Crosswise) sutra from Vedic mathematics. This allows:
  
  * Parallel generation of partial products
  * Structured and scalable multiplication
  * Faster computation compared to conventional shift-and-add multipliers
  
  For 4-bit and 8-bit multipliers:
  
  * Partial products are generated using bitwise operations
  * Aligned partial products are summed hierarchically
  * CLA is used for fast summation

2. Reversible Logic Gates

  The following reversible gates are implemented and used in the CLA design:
  
  Feynman Gate (CNOT)
  
  * Used for XOR and signal copying
  * Helps generate propagate signals
  
  Toffoli Gate (CCNOT)
  
  * Used for AND operations
  * Helps generate generate signals
  
  Peres Gate (Logical Equivalence)
  
  * Functionally represented using Feynman + Toffoli
  * Used for combined XOR and AND based logic
  
  These gates ensure:
  
  * One-to-one input-output mapping
  * Information preservation
  * Reduced theoretical energy loss (Landauer’s principle)

3. Reversible Carry Look-Ahead Adder (CLA)

  The CLA is implemented using reversible logic blocks:
  
  * Reversible Propagate Full Adder (ReversiblePFA)
  * ReversibleCLA4bit
  * ReversibleCLA8bit
  
  Key features:
  
  * Parallel carry computation
  * Reduced carry propagation delay
  * Faster addition compared to ripple carry adder
  * Suitable for high-speed arithmetic units

4. Multiplier + Reversible CLA Integration
 
  * Vedic partial products are generated
  * Partial products are aligned
  * Summation is performed using Reversible CLA instead of the `+` operator
  * This ensures reversible logic is part of the datapath
  
  Garbage outputs are generated internally in reversible blocks but are omitted at the top-level interface for simplicity in functional verification.


Verification Environment (SystemVerilog)

The design is verified using a class-based SystemVerilog verification environment that ensures functional correctness of the reversible CLA based Vedic  multiplier. The verification framework consists of a transaction object, driver, monitor, scoreboard, and environment, all connected using mailboxes and a virtual interface. The driver is responsible for applying randomized and directed stimulus by driving the multiplier inputs (A and B) on clock edges, while the monitor passively observes the DUT signals and converts pin-level activity into high-level transactions. To avoid race conditions and ensure deterministic checking, the monitor captures the input values on one clock cycle and samples the corresponding output on the following clock cycle, thereby cleanly aligning cause (inputs) and effect (outputs) in time. The scoreboard computes the reference result using a behavioral multiplication model (A × B) and compares it against the DUT output, reporting pass or fail for each transaction. This cycle-accurate monitoring methodology provides robust, race-free verification and is scalable to future pipelined or sequential versions of the multiplier design.




