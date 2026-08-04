module IF_ID_reg(
    input clk,
    input reset,
    //input en,- will be used in hazard detection
    input flush,
    input stall,
    input [15:0] instr,
    input [15:0] pc_curr,
    output reg [15:0] instr_out,
    output reg [15:0] pc_curr_out
    );

        always@(posedge clk or posedge reset) begin
    if(reset) begin
        instr_out <= 0;
        pc_curr_out <= 0;
    end
    else if(flush) begin  // synchronous flush
        instr_out <= 0;
        pc_curr_out <= 0;
    end
    else if(stall) begin 
        // do nothing
    end
    else  begin
        instr_out <= instr;
        pc_curr_out <= pc_curr;
    end
end
endmodule
