module load_use(
    input id_ex_mem_to_reg,//will be 1 only for load(to see if the instruction in alu is load)
    input [2:0] id_ex_rd,//destination register of load
    input [2:0] rs1,//rs1 reg of instruction in decode
    input [2:0] rs2,//rs2 reg of instruction in decode
    output reg stall
    );
    always@(*) begin
        stall=0;
        if(id_ex_mem_to_reg && (id_ex_rd==rs1 || id_ex_rd==rs2) && id_ex_rd!=0 ) begin
        stall=1;
        end
        end
endmodule
