module top(
    input clk,
    input reset,
    output [7:0] o_p
    );
    
    wire halt;
    //control signals
    wire pc_write,ir_we,a_we,b_we,reg_write,alu_src,aluout_we;
    wire load_src,mdr_we,mem_write,mem_to_reg;
    //PC
    wire [15:0] pc_curr,pc_next;
    
    //instruction_memory
    wire [15:0] instr;
    
    //instruction register
    wire [15:0] ir_out;
    
    //instruction decode
    wire [2:0] rs1,rs2,rd;
    wire [4:0] opcode,imm;
    wire [7:0] offset;
    
    //registerfile
    wire [15:0] read_val1,read_val2;
    
    //reg_a and reg b
    wire [15:0] reg_a_out,reg_b_out;
    
    //imm_exteng
    wire [15:0] imm_out;
    
    //mux1 using alusrc
    wire [15:0] mux1_out;
    
    //mux2 using load_src
    wire [15:0] offset_extended;
    wire[15:0] alu_in1;
    
    //ALU flags
    wire [15:0] rd_out;
    wire zero,lt,zero_reg;
    assign zero_reg = (reg_a_out == 0) ? 1 : 0;
    
    //reg_ALUOUT
    wire [15:0] rd_out1;
    
    //flagreg 
    wire flag_we;
    wire zero_flag, lt_flag;  // stable flag outputs
    
    //data memory
    wire [15:0] mem_read_data,mdr_out;
    
    //mux memto reg
    wire [15:0] wb_data;
    
    fsm fsm_inst(.clk(clk),
                 .reset(reset),
                 .opcode(opcode),
                 .ir_we(ir_we),
                 .pc_write(pc_write),
                 .reg_write(reg_write),
                 .mem_write(mem_write),
                 .a_we(a_we),
                 .b_we(b_we),
                 .aluout_we(aluout_we),
                 .mdr_we(mdr_we),
                 .mem_to_reg(mem_to_reg),
                 .alu_src(alu_src),
                 .load_src(load_src),
                 .halt(halt),
                 .flag_we(flag_we)
                 );
    
    PC pc_inst(.clk(clk),
                .reset(reset),
                .pc_curr(pc_curr),
                .pc_next(pc_next),
                .pc_write(pc_write)
                );
    
    instruction_memory im_inst(.clk(clk),
                               .pc_curr(pc_curr),
                               .instr(instr)
                               );
    
    instruction_register ir_inst(.clk(clk),
                                 .reset(reset),
                                 .ir_we(ir_we),
                                 .data_in(instr),
                                 .data_out(ir_out)
                                 );
    
    instruction_decode id_inst(.instr(ir_out),
                               .rs1(rs1),
                               .rs2(rs2),
                               .rd(rd),
                               .imm(imm),
                               .opcode(opcode),
                               .offset(offset)
                               );
                               
    register_file rf_inst(.clk(clk),
                          .reset(reset),
                          .reg_write(reg_write),
                          .read_addr1(rs1),
                          .read_addr2(rs2),
                          .write_addr(rd),
                          .write_val(wb_data),
                          .read_val1(read_val1),
                          .read_val2(read_val2)
                           );
    
    reg_A ra_inst(.clk(clk),
                  .we(a_we),
                  .din(read_val1),
                  .dout(reg_a_out)
                  );
                  
    reg_B rb_inst(.clk(clk),
                  .we(b_we),
                  .din(read_val2),
                  .dout(reg_b_out)
                  );
    
    imm_extend ie_inst(.imm(imm),
                       .imm_out(imm_out)
                       );
    
    mux2to1 mux_rs2_imm(.select(alu_src),
                        .din1(reg_b_out),
                        .din2(imm_out),
                        .dout(mux1_out)
                        );
    assign offset_extended={{8{offset[7]}},offset}; 
                       
    mux2to1 mux_rs1(.select(load_src),
                    .din1(reg_a_out),
                    .din2(offset_extended),
                    .dout(alu_in1)
                    );
                        
    ALU alu_inst(.rs1(alu_in1),
                 .rs2(mux1_out),
                 .opcode(opcode),                    
                 .rd(rd_out), 
                 .zero(zero),
                 .lt(lt)
                 );
                 
    reg_ALUOUT ro_inst(.clk(clk),
                       .we(aluout_we),
                       .din(rd_out),
                       .dout(rd_out1)
                       );

    flag_reg flag_inst(
        .clk(clk),
        .we(flag_we),
        .zero_in(zero),
        .lt_in(lt),
        .zero_out(zero_flag),
        .lt_out(lt_flag)
    );


    branch br_inst(.opcode(opcode),
                   .pc(pc_curr),
                   .offset_s(offset),
                   .lt(lt_flag),
                   .zero(zero_flag),
                   .zero_reg(zero_reg),
                   .pc_next(pc_next)
                   );
                   
    data_memory dm_inst(.clk(clk),
                        .addr(rd_out1),
                        .write_data(reg_a_out),
                        .mem_write(mem_write),
                        .read_data(mem_read_data)
                        );
                   
    reg_MDR mdr_inst(.clk(clk),
                        .we(mdr_we),
                        .din(mem_read_data),
                        .dout(mdr_out)
                        ); 
                        
    mux2to1 wb_inst(.select(mem_to_reg),
                    .din1(rd_out1),
                    .din2(mdr_out),
                    .dout(wb_data)
                    ); 
                   
    
    assign o_p=rf_inst.regs[1][7:0];                            
                                             
endmodule