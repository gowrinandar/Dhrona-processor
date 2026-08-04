module reg_MDR(
    input clk,
    input we,
    input [15:0] din,
    output reg [15:0] dout
);
//holds data after memory access; before writing it back to the rd register
    always@(posedge clk)
        if(we) dout <= din;
endmodule