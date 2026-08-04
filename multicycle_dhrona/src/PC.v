module PC(
    input clk,
    input [15:0] pc_next,
    input pc_write,
    input reset,
    output reg [15:0] pc_curr
    );
    always@(posedge clk or posedge reset) begin
    if(reset)
    pc_curr<=0;
    else if(pc_write)
    pc_curr<=pc_next;
    end
endmodule