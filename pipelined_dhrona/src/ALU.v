module ALU(
    input [15:0] rs1,rs2,
    input [4:0] opcode,
    output reg [15:0] rd,
    output reg zero,lt    
    );
    
    reg [15:0] rd_dupe;
    always@(*) begin
    
        case(opcode)
        5'b00000: rd=rs1+rs2;//add
        5'b00001: rd=rs1-rs2;//sub
        5'b00010: rd=rs1&rs2;//and
        5'b00011: rd=rs1|rs2;//or
        5'b00100: rd=~rs1;//not
        5'b00101: rd=rs1^rs2;//xor
        5'b00110: rd=((rs1-rs2==0)?1:0);//cmp
        5'b00111: rd=~(rs1&rs2);//nand
        5'b01000: rd=~(rs1|rs2);//nor
        5'b01001: rd=rs1~^rs2;//xnor
        5'b01010: rd=rs1>>rs2[3:0];//logical shift right
        5'b01011: rd=rs1<<rs2[3:0];//logical shift left
        5'b01100: rd=rs1+rs2;//immediate add
        5'b01101: rd=rs1-rs2;//immediate sub
        5'b01110: rd=rs1&rs2;//immediate and
        5'b01111: rd=rs1|rs2;//immediate or
        5'b10000: rd=~rs1;//immediate not
        5'b10001: rd=rs1^rs2;//immediate xor
        5'b10010: rd=rs1>>rs2[3:0];//immediate logical right shift
        5'b10011: rd=rs1<<rs2[3:0];//immediate logical left shift
        5'b10100: rd=rs1;//calculating load address-just offset
        5'b10101: rd=rs1;//calculating store address-again just offset
        //5'b10110 jmp operation alu not used
        //5'b10111-jmplt flag-lt
        //5'b11000-jmpgt flag- ~lt
        //5'b11001-jmpeq flag-zero
        //5'b11010-jmpneq flag- ~zero
        //5'b11011-jmpeqz flag-zero_reg jump if register rs1 is equal to zero
        //5'b11100-jmpneqz flag- ~zero_reg jump if register not equal to zero
        5'b11101: rd=rs1;//mov
        //5'b11110 not used in multicycle but nop in pipelining
        //5'b11111 hlt controlled by control unit
        default: rd=16'b0;
        endcase
        
        rd_dupe=rd;
        zero=(rd==0)?1:0;
        lt=($signed(rd_dupe)<0)?1:0;
        //will calculate in top module zero_reg=(rs1==0)?1:0;
        
    end
endmodule