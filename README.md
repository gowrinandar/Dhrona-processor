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

---

### 1. Multicycle Processor (`/multicycle`)

A multicycle implementation where each instruction takes exactly 5 clock cycles to complete.

**Architecture:**
- 5-state FSM controller (FETCH → DECODE → EXECUTE → MEMORY → WRITEBACK)
- Intermediate registers: Instruction Register (IR), Reg A, Reg B, ALU OUT, MDR
- Separate instruction and data memories (256 × 16-bit each)
- Dedicated branch unit for PC computation
- Flag register for condition codes (zero, lt, zero_reg)

**Modules:**
| Module | Description |
|--------|-------------|
| `top.v` | Top-level datapath |
| `fsm.v` | 5-state FSM controller |
| `ALU.v` | 32-operation ALU |
| `PC.v` | Program counter |
| `branch.v` | Branch target computation |
| `register_file.v` | 4 × 16-bit register file |
| `instruction_memory.v` | 256 × 16-bit ROM |
| `data_memory.v` | 256 × 16-bit RAM |
| `instruction_decode.v` | Instruction field extractor |
| `instruction_register.v` | IR latch |
| `imm_extend.v` | 5-bit sign extender |
| `flag_reg.v` | Condition flag register |
| `reg_A/B/ALUOUT/MDR.v` | Intermediate pipeline registers |
| `mux_2to1.v` | 2:1 MUX |

**Verified instructions:** All 32 instructions verified in simulation and tested on Nexys A7 FPGA hardware.

---

## Pipelined Architecture
- 5-stage pipeline: IF → ID → EX → MEM → WB
- Harvard architecture with BRAM instruction memory
- **Data hazard resolution** via operand forwarding (EX/MEM and MEM/WB paths)
- **Load-use hazard detection** with automatic bubble insertion
- **Control hazard handling** via flush-on-taken with predict-not-taken
- **Flag forwarding** eliminating NOPs between arithmetic and branch instructions
- r0 hardwired to zero — writes to r0 ignored, flags not updated on r0 destination
- Verified on Nexys FPGA

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
