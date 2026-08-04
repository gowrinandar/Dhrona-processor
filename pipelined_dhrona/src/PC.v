module PC(
    input clk,
    input reset,
    input branch,
    input [15:0] branch_target,
    input stall,
    output reg [15:0] pc_curr
    );
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            pc_curr<=16'b0;
        end
        else if(stall) begin
            pc_curr<=pc_curr;
        end
        else if(branch) begin
            pc_curr<=branch_target;
        end
        else begin
            pc_curr<=pc_curr+1;
        end
    end
endmodule