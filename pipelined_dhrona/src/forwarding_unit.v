module forwarding_unit(
    input [2:0] id_ex_rs1,// rs1 address of current instruction in EX
    input [2:0] id_ex_rs2,// rs2 address of current instruction in EX
    input [2:0] ex_mem_rd,// destination register of instruction in MEM
    input ex_mem_reg_write,// does instruction in MEM write to register
    input [2:0] mem_wb_rd,// destination register of instruction in WB
    input mem_wb_reg_write,// does instruction in WB write to register
    
    output reg [1:0] forward_a,// MUX select for ALU rs1
    output reg [1:0] forward_b// MUX select for ALU rs2
    );
    
    /*00 → use register file value (id_ex_rs1/rs2)
    01 → forward from EX/MEM
    10 → forward from MEM/WB*/
    
    always@(*) begin
        forward_a=2'b00;
        forward_b=2'b00;
        
        /*add r1, r2, r3   // WB stage  → wants to forward r1
        add r1, r4, r5   // MEM stage → wants to forward r1
        add r6, r1, r7   // EX stage  → we use mem stage r1 here so higher priority for that*/
        
        if(ex_mem_reg_write && ex_mem_rd != 3'b0 && id_ex_rs1 == ex_mem_rd)//higher priority for forwarding from the me stage that wb stage
        forward_a = 2'b01;
        else if(mem_wb_reg_write && mem_wb_rd != 3'b0 && id_ex_rs1 == mem_wb_rd)
        forward_a = 2'b10;

        if(ex_mem_reg_write && ex_mem_rd != 3'b0 && id_ex_rs2 == ex_mem_rd)
        forward_b = 2'b01;
        else if(mem_wb_reg_write && mem_wb_rd != 3'b0 && id_ex_rs2 == mem_wb_rd)
        forward_b = 2'b10;
        
    end
endmodule
