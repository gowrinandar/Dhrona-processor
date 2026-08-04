module mux2to1(
    input select,
    input [15:0] din1,
    input [15:0] din2,
    output reg [15:0] dout
    );
    always@(*) begin
        if(select) 
            dout=din2;
        else
            dout=din1;
    end
endmodule