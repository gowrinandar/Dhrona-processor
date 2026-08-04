module MEM_WB_reg(
    input clk,
    input reset,
    input reg_write,
    input [2:0] rd,
    input [15:0] alu,
    input mem_to_reg,
    input [15:0] mem_read_data,
    input halt,
    
    output reg reg_write_out,
    output reg [2:0] rd_out,
    output reg [15:0] alu_out,
    output reg mem_to_reg_out,
    output reg [15:0] mem_read_data_out,
    output reg halt_out
    );
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            reg_write_out<=0;
            rd_out<=0;
            alu_out<=0;
            mem_to_reg_out<=0;
            mem_read_data_out<=0;
            halt_out<=0;
        end
        else begin
            reg_write_out<=reg_write;
            rd_out<=rd;
            alu_out<=alu;
            mem_to_reg_out<=mem_to_reg;
            mem_read_data_out<=mem_read_data;
            halt_out<=halt;
        end
    end
endmodule
