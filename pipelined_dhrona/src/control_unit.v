module control_unit(
    input [4:0] opcode,
    output reg alu_src,//to choose between rs2 or immediete
    output reg load_src,//to choose between offset for load/store or rs1
    output reg is_branch,//to denote if branch is taken or not
    output reg flag_we,//flag resister enable
    output reg mem_write,//enables data memory write
    output reg mdr_we,//not needed in pipeline architecture
    output reg mem_to_reg,//selects between ALU result and memory read data
    output reg reg_write,//enagles register write
    output reg halt
    );
    always@(*) begin
        alu_src=0;
        load_src=0;
        is_branch=0;
        flag_we=0;
        mem_write=0;
        mdr_we=0;
        mem_to_reg=0;
        reg_write=0;
        halt=0;
        
        if(opcode>=5'b01100 && opcode<=5'b10011) 
            alu_src=1;
        if(opcode==5'b10100 || opcode==5'b10101)
            load_src=1;//branches dont need load_src as we use offset directly there
        if(opcode>=5'b10110 && opcode<=5'b11100)
            is_branch=1;
        if(opcode>=5'b00000 && opcode<=5'b10011) 
            flag_we=1;
        if(opcode==5'b10101)
            mem_write=1;
        if(opcode==5'b10100)
            mdr_we=1;
        if(opcode==5'b10100)
            mem_to_reg=1;
        if((opcode>=5'b00000 && opcode<=5'b10011)||opcode==5'b10100 ||opcode==5'b11101)
            reg_write=1;
        if(opcode==5'b11111)
            halt=1;
    end
endmodule
