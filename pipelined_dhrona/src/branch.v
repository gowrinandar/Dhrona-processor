module branch(
    input [4:0] opcode,
    input [15:0] pc,
    input [15:0] offset,
    input lt,
    input zero,
    input zero_reg,
    output reg [15:0] pc_next,
    output reg branch_taken
    );
    //relative jumps are done here unlike loadand store to provide more flexibility
    //more address locations can be accessed
    always@(*) begin
        pc_next=pc;
        branch_taken=0;
        case(opcode)
        5'b10110: begin//jmp
        pc_next=pc+offset;
        branch_taken=1;
        end
        5'b10111: begin//jmplt
        if(lt) begin
        pc_next=pc+offset;
        branch_taken=1;
        end
        end
        5'b11000: begin//jmpgt
        if(~lt && ~zero) begin
        pc_next=pc+offset;
        branch_taken=1;
        end 
        end
        5'b11001: begin//jmpeq
        if( zero)begin
        pc_next=pc+offset;
        branch_taken=1;
        end
        end
        5'b11010: begin//jmpneq
        if(~zero) begin
        pc_next=pc+offset;
        branch_taken=1;
        end 
        end
        5'b11011: begin//jmpeqz
        if(zero_reg)begin
        pc_next=pc+offset;
        branch_taken=1;
        end 
        end
        5'b11100: begin//jmpneqz
        if(~zero_reg) begin
        pc_next=pc+offset;
        branch_taken=1;
        end 
        end
        default: pc_next=pc;
        endcase
    end
endmodule