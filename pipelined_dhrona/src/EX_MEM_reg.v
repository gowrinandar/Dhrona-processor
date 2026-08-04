module EX_MEM_reg(
    input clk,
    input reset,
    input [15:0] alu,
    input [2:0] rd,
    input [15:0] rs1,
    input mem_write,
    input mdr_we,
    input mem_to_reg,
    input reg_write,
    input halt,
    
    output reg [15:0] alu_out,//memory address (for load/store) or ALU result (for arithmetic)
    output reg [2:0] rd_out,//destination register address (for load and arithmetic)
    output reg [15:0] rs1_out,//value to store into memory (for store instruction)
    output reg mem_write_out,//enables store
    output reg mdr_we_out,//
    output reg mem_to_reg_out,//selects MDR or ALU result for writeback
    output reg reg_write_out,//enables writeback
    output reg halt_out
    );
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            alu_out<=0;
            rd_out<=0;
            rs1_out<=0;
            mem_write_out<=0;
            mdr_we_out<=0;
            mem_to_reg_out<=0;
            reg_write_out<=0;
            halt_out<=0;
        end
        else begin
            alu_out<=alu;
            rd_out<=rd;
            rs1_out<=rs1;
            mem_write_out<=mem_write;
            mdr_we_out<=mdr_we;
            mem_to_reg_out<=mem_to_reg;
            reg_write_out<=reg_write;
            halt_out<=halt;
        end
    end
endmodule
