module ID_EX_reg(
    input clk,
    input reset,
    input flush,
    input bubble,
    input [15:0] pc,
    input reg_write,
    input mem_write,
    input mdr_we,
    input alu_src,
    input load_src,
    input mem_to_reg,
    input is_branch,
    input halt,
    input [15:0] rs1,rs2,
    input [2:0] rd,
    input [4:0] opcode,
    input [15:0] imm,
    input [15:0] offset,
    input flag_we,
    input [2:0] rs1_addr,  // register address for forwarding
    input [2:0] rs2_addr,  // register address for forwarding
              
    output reg flag_we_out,  
    output reg [15:0] pc_out,
    output reg [15:0] rs1_out,rs2_out,
    output reg [2:0] rd_out,
    output reg [4:0] opcode_out,
    output reg [15:0] imm_out,
    output reg [15:0] offset_out,
    output reg reg_write_out,
    output reg mem_write_out,
    output reg mdr_we_out,
    output reg alu_src_out,
    output reg load_src_out,
    output reg mem_to_reg_out,
    output reg is_branch_out,
    output reg halt_out,
    output reg [2:0] rs1_addr_out,
    output reg [2:0] rs2_addr_out
    );
    
    always@(posedge clk or posedge reset) begin
        if(reset || flush) begin
            pc_out<=0;
            rs1_out<=0; 
            rs2_out<=0; 
            rd_out<=0;
            opcode_out<=0; 
            imm_out<=0; 
            offset_out<=0;
            reg_write_out<=0; 
            mem_write_out<=0; 
            mdr_we_out<=0;
            alu_src_out<=0; 
            load_src_out<=0; 
            mem_to_reg_out<=0;
            is_branch_out<=0; 
            halt_out<=0;
            flag_we_out <= 0;
            rs1_addr_out <= 0;
            rs2_addr_out <= 0;
        end
        else if(bubble) begin
            pc_out<=0;
            rs1_out<=0; 
            rs2_out<=0; 
            rd_out<=0;
            opcode_out<=11110; //inserting nop
            imm_out<=0; 
            offset_out<=0;
            reg_write_out<=0; 
            mem_write_out<=0; 
            mdr_we_out<=0;
            alu_src_out<=0; 
            load_src_out<=0; 
            mem_to_reg_out<=0;
            is_branch_out<=0; 
            halt_out<=0;
            flag_we_out <= 0;
            rs1_addr_out <= 0;
            rs2_addr_out <= 0;
        end
        else begin
            pc_out<=pc; 
            rs1_out<=rs1; 
            rs2_out<=rs2; 
            rd_out<=rd;
            opcode_out<=opcode; 
            imm_out<=imm; 
            offset_out<=offset;
            reg_write_out<=reg_write; 
            mem_write_out<=mem_write; 
            mdr_we_out<=mdr_we;
            alu_src_out<=alu_src; 
            load_src_out<=load_src; 
            mem_to_reg_out<=mem_to_reg;
            is_branch_out<=is_branch; 
            halt_out<=halt;
            flag_we_out <= flag_we;
            rs1_addr_out <= rs1_addr;
            rs2_addr_out <= rs2_addr;
        end
    end
endmodule