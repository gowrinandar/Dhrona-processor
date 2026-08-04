module branch(
    input [4:0] opcode,
    input [15:0] pc,
    input [7:0] offset_s,
    input lt,
    input zero,
    input zero_reg,
    output reg [15:0] pc_next
    );
    //relative jumps are done here unlike loadand store to provide more flexibility
    //more address locations can be accessed
    wire [15:0] offset;
    assign offset={{8{offset_s[7]}},offset_s};
    always@(*) begin
        pc_next=pc+1;
        
        case(opcode)
        5'b10110: begin//jmp
        pc_next=pc+1+offset;
        end
        5'b10111: begin//jmplt
        if(lt)
        pc_next=pc+1+offset;
        end
        5'b11000: begin//jmpgt
        if(~lt && ~zero)
        pc_next=pc+1+offset;
        end 
        5'b11001: begin//jmpeq
        if( zero)
        pc_next=pc+1+offset;
        end
        5'b11010: begin//jmpneq
        if(~zero) 
        pc_next=pc+1+offset;
        end 
        5'b11011: begin//jmpeqz
        if(zero_reg)
        pc_next=pc+1+offset;
        end 
        5'b11100: begin//jmpneqz
        if(~zero_reg) 
        pc_next=pc+1+offset;
        end 
        default: pc_next=pc+1;
        endcase
    end
endmodule