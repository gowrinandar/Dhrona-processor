module top(
    input clk,
    input reset,
    output halt,
    output [7:0] o_p
);

// misc wires
wire cu_halt;
wire id_ex_mdr_we;
wire ex_mem_mdr_we;

// IF stage wires
wire [15:0] pc_curr, instr;

// IF_ID wires
wire [15:0] if_id_instr, if_id_pc;

// ID stage wires
wire [2:0] rs1, rs2, rd;
wire [4:0] opcode;
wire [4:0] imm;
wire [7:0] offset;
wire [15:0] read_val1, read_val2;
wire [15:0] imm_out, off_out;
wire alu_src, load_src, is_branch, flag_we;
wire mem_write, mem_to_reg, reg_write;
wire flush, branch_taken;

// ID_EX wires
wire [15:0] id_ex_pc, id_ex_rs1, id_ex_rs2;
wire [2:0]  id_ex_rd;
wire [4:0]  id_ex_opcode;
wire [15:0] id_ex_imm, id_ex_offset;
wire id_ex_alu_src, id_ex_load_src, id_ex_is_branch;
wire id_ex_flag_we, id_ex_mem_write, id_ex_mem_to_reg;
wire id_ex_reg_write, id_ex_halt;
wire [2:0] id_ex_rs1_addr, id_ex_rs2_addr; 

// EX stage wires
wire [15:0] mux1_out, mux2_out;
wire [15:0] alu_result;
wire zero, lt, zero_flag, lt_flag, zero_reg;
wire [15:0] branch_target;

// EX_MEM wires
wire [15:0] ex_mem_alu, ex_mem_rs1;
wire [2:0]  ex_mem_rd;
wire ex_mem_mem_write, ex_mem_mdr_we;
wire ex_mem_mem_to_reg, ex_mem_reg_write, ex_mem_halt;

// MEM stage wires
wire [15:0] mem_read_data;

// MEM_WB wires
wire [15:0] mem_wb_alu, mem_wb_mem_data;
wire [2:0]  mem_wb_rd;
wire mem_wb_mem_to_reg, mem_wb_reg_write, mem_wb_halt;

// WB stage wires
wire [15:0] wb_data;

wire stall;

// flush and zero_reg
assign flush = branch_taken;
assign zero_reg = (id_ex_rs1 == 0) ? 1 : 0;
assign halt = mem_wb_halt;

// IF stage
PC pc_inst(
    .clk(clk),
    .reset(reset),
    .branch(branch_taken),
    .branch_target(branch_target),
    .stall(stall),
    .pc_curr(pc_curr)
);

instruction_memory im_inst(
    .clk(clk),
    .pc_curr(pc_curr),
    .instr(instr)
);

IF_ID_reg if_id_inst(
    .clk(clk),
    .reset(reset),
    .flush(flush),
    .instr(instr),
    .stall(stall),
    .pc_curr(pc_curr),
    .instr_out(if_id_instr),
    .pc_curr_out(if_id_pc)
);

// ID stage
instruction_decode id_inst(
    .instr(if_id_instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .imm(imm),
    .opcode(opcode),
    .offset(offset)
);


load_use lu_inst(
    .rs1(rs1),
    .rs2(rs2),
    .id_ex_mem_to_reg(id_ex_mem_to_reg),
    .id_ex_rd(id_ex_rd),
    .stall(stall)
    );

register_file rf_inst(
    .clk(clk),
    .reset(reset),
    .reg_write(mem_wb_reg_write),
    .read_addr1(rs1),
    .read_addr2(rs2),
    .write_addr(mem_wb_rd),
    .write_val(wb_data),
    .read_val1(read_val1),
    .read_val2(read_val2)
);

control_unit cu_inst(
    .opcode(opcode),
    .alu_src(alu_src),
    .load_src(load_src),
    .is_branch(is_branch),
    .flag_we(flag_we),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .reg_write(reg_write),
    .halt(cu_halt)
);

extend ext_inst(
    .imm(imm),
    .offset(offset),
    .imm_out(imm_out),
    .off_out(off_out)
);

ID_EX_reg id_ex_inst(
    .clk(clk),
    .reset(reset),
    .flush(flush),
    .bubble(stall),
    .pc(if_id_pc),
    .reg_write(reg_write),
    .mem_write(mem_write),
    .mdr_we(1'b0),
    .alu_src(alu_src),
    .load_src(load_src),
    .mem_to_reg(mem_to_reg),
    .is_branch(is_branch),
    .flag_we(flag_we),
    .halt(cu_halt),
    .rs1(read_val1),
    .rs2(read_val2),
    .rd(rd),
    .opcode(opcode),
    .imm(imm_out),
    .offset(off_out),
    .pc_out(id_ex_pc),
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),
    .rd_out(id_ex_rd),
    .opcode_out(id_ex_opcode),
    .imm_out(id_ex_imm),
    .offset_out(id_ex_offset),
    .reg_write_out(id_ex_reg_write),
    .mem_write_out(id_ex_mem_write),
    .mdr_we_out(id_ex_mdr_we),
    .alu_src_out(id_ex_alu_src),
    .load_src_out(id_ex_load_src),
    .mem_to_reg_out(id_ex_mem_to_reg),
    .is_branch_out(id_ex_is_branch),
    .flag_we_out(id_ex_flag_we),
    .halt_out(id_ex_halt),
    .rs1_addr(rs1),          // rs1 address from decode
    .rs2_addr(rs2),          // rs2 address from decode
    .rs1_addr_out(id_ex_rs1_addr),
    .rs2_addr_out(id_ex_rs2_addr)
);

//for forwarding
// 3:1 forwarding mux for rs1
wire [15:0] fwd_rs1;
wire [1:0] forward_a;
assign fwd_rs1 = (forward_a == 2'b01) ? ex_mem_alu :
                 (forward_a == 2'b10) ? wb_data :
                 id_ex_rs1;
                 
// 3:1 forwarding mux for rs2
wire [15:0] fwd_rs2;
wire [1:0] forward_b;
assign fwd_rs2 = (forward_b == 2'b01) ? ex_mem_alu :
                 (forward_b == 2'b10) ? wb_data :
                 id_ex_rs2; 
                   
forwarding_unit fu_inst(
    .id_ex_rs1(id_ex_rs1_addr),
    .id_ex_rs2(id_ex_rs2_addr),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .forward_a(forward_a),
    .forward_b(forward_b)
);                              

// EX stage
mux2to1 mux_alu_src(
    .select(id_ex_alu_src),
    .din1(fwd_rs2), 
    .din2(id_ex_imm),
    .dout(mux1_out)
);

mux2to1 mux_load_src(
    .select(id_ex_load_src),
    .din1(fwd_rs1),
    .din2(id_ex_offset),
    .dout(mux2_out)
);

ALU alu_inst(
    .rs1(mux2_out),
    .rs2(mux1_out),
    .opcode(id_ex_opcode),
    .rd(alu_result),
    .zero(zero),
    .lt(lt)
);

flag_reg flag_inst(
    .clk(clk),
    .we(id_ex_flag_we),
    .zero_in(zero),
    .lt_in(lt),
    .zero_out(zero_flag),
    .lt_out(lt_flag)
);

wire branch_zero = id_ex_flag_we ? zero : zero_flag;
wire branch_lt   = id_ex_flag_we ? lt : lt_flag;
branch br_inst(
    .opcode(id_ex_opcode),
    .pc(id_ex_pc),
    .offset(id_ex_offset),
    .lt(branch_lt),
    .zero(branch_zero),
    .zero_reg(zero_reg),
    .pc_next(branch_target),
    .branch_taken(branch_taken)
);

EX_MEM_reg ex_mem_inst(
    .clk(clk),
    .reset(reset),
    .alu(alu_result),
    .rd(id_ex_rd),
    .rs1(fwd_rs1),
    .mem_write(id_ex_mem_write),
    .mdr_we(id_ex_mdr_we),
    .mem_to_reg(id_ex_mem_to_reg),
    .reg_write(id_ex_reg_write),
    .halt(id_ex_halt),
    .alu_out(ex_mem_alu),
    .rd_out(ex_mem_rd),
    .rs1_out(ex_mem_rs1),
    .mem_write_out(ex_mem_mem_write),
    .mdr_we_out(ex_mem_mdr_we),
    .mem_to_reg_out(ex_mem_mem_to_reg),
    .reg_write_out(ex_mem_reg_write),
    .halt_out(ex_mem_halt)
);

// MEM stage
data_memory dm_inst(
    .clk(clk),
    .addr(ex_mem_alu),
    .write_data(ex_mem_rs1),
    .mem_write(ex_mem_mem_write),
    .read_data(mem_read_data)
);

MEM_WB_reg mem_wb_inst(
    .clk(clk),
    .reset(reset),
    .reg_write(ex_mem_reg_write),
    .rd(ex_mem_rd),
    .alu(ex_mem_alu),
    .mem_to_reg(ex_mem_mem_to_reg),
    .mem_read_data(mem_read_data),
    .halt(ex_mem_halt),
    .reg_write_out(mem_wb_reg_write),
    .rd_out(mem_wb_rd),
    .alu_out(mem_wb_alu),
    .mem_to_reg_out(mem_wb_mem_to_reg),
    .mem_read_data_out(mem_wb_mem_data),
    .halt_out(mem_wb_halt)
);

// WB stage
mux2to1 wb_mux(
    .select(mem_wb_mem_to_reg),
    .din1(mem_wb_alu),
    .din2(mem_wb_mem_data),
    .dout(wb_data)
);

//assign o_p = rf_inst.regs[1][7:0];
assign o_p = rf_inst.regs[4][7:0];  // show r4=25

endmodule