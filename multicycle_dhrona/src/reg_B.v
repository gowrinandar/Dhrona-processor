module reg_B(
    input clk,
    input we,
    input [15:0] din,
    output reg [15:0] dout
);
    //for holding rs2 after decodingg
    //sits between instruction_decode and mux2to1 for deciding rs2 or immediate value
    always@(posedge clk)
        if(we) dout <= din;
endmodule