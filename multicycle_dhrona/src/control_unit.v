module control_unit(
    input [4:0] opcode,
    output reg alu_src,
    output reg reg_write,
    output reg mem_write,
    output reg mem_to_reg,
    output reg is_branch,
    output reg halt
    );
    
    always@(*) begin
    alu_src=0;
    reg_write=1;
    mem_write=0;
    mem_to_reg=0;
    is_branch=0;
    halt=0;
    if (opcode>=5'b10110 && opcode<=5'b11100) 
        is_branch=1;
    if(opcode==5'b11111) begin
        halt=1;
        reg_write=0;
    end
    if(opcode>=5'b00000 && opcode<=5'b01011)
        alu_src=0;//register type
    else
        alu_src=1;//immediate type
    if (opcode==5'b10101)  // store
        mem_write = 1;
    if (opcode==5'b10100)  // load
        mem_to_reg = 1;
    if (opcode==5'b10101)  // store
        reg_write = 0;
    if (opcode>=5'b10110 && opcode<=5'b11100)  // branches
        reg_write = 0;
    end
endmodule