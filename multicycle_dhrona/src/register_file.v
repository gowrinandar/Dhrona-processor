module register_file#(parameter data_width=16)(
    input clk,
    input reset,
    input reg_write,
    input [2:0] read_addr1,read_addr2,
    input [2:0] write_addr,
    input [15:0] write_val,
    output [15:0] read_val1,read_val2
    );
    reg [data_width-1:0] regs[0:3];
    integer i;
    assign read_val1=(read_addr1<=3'b011)?regs[read_addr1]:{data_width{1'b0}};
    assign read_val2=(read_addr2<=3'b011)?regs[read_addr2]:{data_width{1'b0}};
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            for(i=0;i<4;i=i+1) begin
                regs[i]={data_width{1'b0}};
            end
        end
        else if(reg_write && write_addr<=3'b011) begin
            regs[write_addr]<=write_val;
        end
    end
endmodule