module flag_reg(
    input clk,
    input we,
    input zero_in,
    input lt_in,
    output reg zero_out,
    output reg lt_out
);
//flags are needed for branching operations
    always@(posedge clk) begin
        if(we) begin
            zero_out <= zero_in;
            lt_out   <= lt_in;
        end
    end
endmodule