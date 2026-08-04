# Dhrona — 16-bit Processor

A 16-bit processor implemented in Verilog HDL from a provided ISA 
specification, developed as part of a CDAC internship project.
The design was implemented in two architectures - a multicycle 
processor and a pipelined processor.

## ISA Overview
- 16-bit instruction width
- 32 instructions across 6 types: R-type, I-type, Load, Store, Branch, Halt
- 8 general-purpose registers (r0-r7), r0 hardwired to zero
- 8-bit sign-extended offset for branches and memory access
- Harvard architecture — separate instruction and data memory

---

### 1. Multicycle Processor (`/multicycle`)

A multicycle implementation where each instruction takes exactly 6 clock cycles to complete.

**Architecture:**
- 6-state FSM controller (FETCH_WAIT → FETCH → DECODE → EXECUTE → MEMORY → WRITEBACK)
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

**Verified instructions:** All 32 instructions verified in simulation and tested on Zedboard.

---

### 2. Pipelined Processor (`/pipeline`)

A 5-stage pipelined implementation with full hazard handling, achieving single-cycle throughput after pipeline fill.

**Architecture:**
- 5-stage pipeline: FETCH → DECODE → EXECUTE → MEMORY → WRITEBACK
- Pipeline registers: IF/ID, ID/EX, EX/MEM, MEM/WB
- r0 hardwired to 0 (RISC-V convention)
- 8 general-purpose registers (r0-r7, r0 fixed at 0)

**Hazard Handling:**

| Hazard Type | Solution |
|-------------|----------|
| Data hazard (RAW) | Forwarding unit — routes EX/MEM and MEM/WB results directly to ALU inputs |
| Load-use hazard | Hazard detection unit — inserts 1-cycle stall + forwarding from MEM/WB |
| Control hazard | Flush on taken — flushes IF/ID and ID/EX when branch resolves in EXECUTE |

**Modules:**
| Module | Description |
|--------|-------------|
| `top.v` | Top-level datapath |
| `PC.v` | Program counter with branch and stall support |
| `IF_ID_reg.v` | IF/ID pipeline register with flush and stall |
| `ID_EX_reg.v` | ID/EX pipeline register with flush and bubble |
| `EX_MEM_reg.v` | EX/MEM pipeline register |
| `MEM_WB_reg.v` | MEM/WB pipeline register |
| `forwarding_unit.v` | Detects and resolves data hazards via forwarding |
| `load_use.v` | Detects load-use hazards and generates stall signal |
| `control_unit.v` | Combinational control signal generator |
| `ALU.v` | 32-operation ALU |
| `branch.v` | Branch condition evaluation and target computation |
| `register_file.v` | 8 × 16-bit register file (r0 hardwired to 0) |
| `instruction_memory.v` | 256 × 16-bit ROM |
| `data_memory.v` | 256 × 16-bit RAM |
| `instruction_decode.v` | Instruction field extractor |
| `flag_reg.v` | Condition flag register |
| `extend.v` | 5-bit immediate and 8-bit offset sign extender |
| `mux2to1.v` | 2:1 MUX |

**Verified:** Forwarding, load-use stall, and branch flush verified in simulation.

---

## Tools
- Verilog HDL
- Xilinx Vivado
- Zedboard (Zynq-7000) - multicycle
- Nexys FPGA - pipelined

## Key Design Decisions
- **Flag register** - flags latched only after arithmetic/logical 
  instructions, preventing branch from reading stale ALU outputs
- **FETCH_WAIT state** - extra FSM state in multicycle to absorb 
  BRAM's 1-cycle synchronous read latency
- **Predict-not-taken** - simple branch strategy; flush on misprediction
- **Harvard architecture** - separate instruction ROM and data RAM 
  enabling simultaneous fetch and memory access
