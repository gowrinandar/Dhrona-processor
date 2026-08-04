module instruction_decode(
    input [15:0] instr,
    output reg [2:0] rs1,rs2,rd,
    output [4:0] opcode,
    output reg [4:0] imm,
    output reg [7:0] offset
    );
    wire [4:0] opc;
    assign opc=instr[4:0];
    assign opcode=opc;
    always@(*) begin
    
        //initial values
        rs1=3'b0;
        rs2=3'b0;
        rd=3'b0;
        imm=5'b0;
        offset=8'b0;
            
        if(opc>=5'b00000 && opc<=5'b01011) begin
            rs1=instr[7:5];
            rs2=instr[10:8];
            rd=instr[13:11];
        end 
        else if(opc>=5'b01100 && opc<=5'b10011) begin
            rs1=instr[7:5];
            imm={instr[15:14],instr[10:8]};
            rd=instr[13:11];
        end
        else if(opc==5'b10100) begin
            offset={instr[15:14],instr[10:5]};
            rd=instr[13:11];
        end
        else if(opc==5'b10101) begin
            offset=instr[15:8];
            rs1=instr[7:5];
        end
        else if(opc>=5'b10110 && opc<=5'b11100) begin
            offset=instr[15:8];
            rs1=instr[7:5];
        end
        else if(opc==5'b11101) begin
            rd=instr[13:11];
            rs1=instr[7:5];
        end
    end
endmodule