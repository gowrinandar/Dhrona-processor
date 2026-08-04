module reg_A(
    input clk,
    input we,
    input [15:0] din,
    output reg [15:0] dout
);
    //for holding rs1 after decodingg
    //sits between instruction_decode and alu
    always@(posedge clk)
        if(we) dout <= din;
endmodule