# Dhrona — 16-bit Processor

A 16-bit processor implemented in Verilog HDL from a provided ISA 
specification, developed as part of a CDAC internship project.
The design was implemented in two architectures — a multicycle 
processor and a pipelined processor.

## ISA Overview
- 16-bit instruction width
- 32 instructions across 6 types: R-type, I-type, Load, Store, Branch, Halt
- 8 general-purpose registers (r0-r7), r0 hardwired to zero
- 8-bit sign-extended offset for branches and memory access
- Harvard architecture — separate instruction and data memory

## Multicycle Architecture
- 6-state FSM: FETCH_WAIT → FETCH → DECODE → EXECUTE → MEMORY → WRITEBACK
- BRAM-based instruction memory initialized via COE file
- FETCH_WAIT state added to handle BRAM read latency
- Dedicated flag register to resolve branch-flag timing hazard
- Verified on Zedboard (Xilinx Zynq-7000) FPGA

## Pipelined Architecture
- 5-stage pipeline: IF → ID → EX → MEM → WB
- Harvard architecture with BRAM instruction memory
- **Data hazard resolution** via operand forwarding (EX/MEM and MEM/WB paths)
- **Load-use hazard detection** with automatic bubble insertion
- **Control hazard handling** via flush-on-taken with predict-not-taken
- **Flag forwarding** eliminating NOPs between arithmetic and branch instructions
- r0 hardwired to zero — writes to r0 ignored, flags not updated on r0 destination
- Verified on Nexys FPGA

## Verified Programs
| Program | Result | Notes |
|---------|--------|-------|
| Fibonacci | r1 = 34 | 8th Fibonacci number |
| GCD | r1 = 4 | GCD(12, 8) |
| Power of 2 | r1 = 256 | 2^8 via repeated doubling |
| Forwarding test | r3 = 8 | Back-to-back dependent instructions |

## Tools
- Verilog HDL
- Xilinx Vivado
- Zedboard (Zynq-7000) — multicycle
- Nexys FPGA — pipelined

## Key Design Decisions
- **Flag register** — flags latched only after arithmetic/logical 
  instructions, preventing branch from reading stale ALU outputs
- **FETCH_WAIT state** — extra FSM state in multicycle to absorb 
  BRAM's 1-cycle synchronous read latency
- **Predict-not-taken** — simple branch strategy; flush on misprediction
- **Harvard architecture** — separate instruction ROM and data RAM 
  enabling simultaneous fetch and memory access
