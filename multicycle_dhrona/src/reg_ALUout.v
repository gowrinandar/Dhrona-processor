module reg_ALUOUT(
    input clk,
    input we,
    input [15:0] din,
    output reg [15:0] dout
);
    //sits after slu and holds the alu result
    always@(posedge clk)
        if(we) dout <= din;
endmodule