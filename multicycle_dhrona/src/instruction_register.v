module instruction_register(
    input clk,
    input reset,
    input ir_we,
    input [15:0] data_in,
    output reg [15:0] data_out 
    );
    //sits between instruction memory and instruction decode
    always@(posedge clk) begin
        if(reset)
        data_out<=16'b0;
        else if(ir_we)
        data_out<=data_in;
    end
endmodule