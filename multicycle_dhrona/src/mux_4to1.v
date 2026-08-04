module mux4to1(
    input [1:0] select1,
    input din1,din2,din3,din4,
    output reg dout
    );
    always@(*) begin
        case(select1) 
        2'b00: dout=din1;
        2'b01: dout=din2;
        2'b10: dout=din3;
        2'b11: dout=din4;
        default: dout=2'b00;
        endcase
    end
endmodule
