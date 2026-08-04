/*module instruction_memory(
    input [15:0] pc_curr,
    output [15:0] instr
    );
    reg [15:0] mem [0:255];
    assign instr=mem[pc_curr];
    
    initial begin
    $readmemh("C:/Vivado_Files/project__pipeline/program.mem", mem);
end
    
endmodule*/

/*module instruction_memory(
    input clk,
    input [15:0] pc_curr,
    output [15:0] instr
    );
    
    blk_mem_gen_0 bram_inst(
        .clka(clk),
        .addra(pc_curr[7:0]),
        .douta(instr),
        .ena(1'b1)
    );
endmodule*/

module instruction_memory(
    input clk,
    input [15:0] pc_curr,
    output [15:0] instr
    );
    blk_mem_gen_0 bram_inst(
        .clka(clk),
        .addra(pc_curr[7:0]),
        .douta(instr),
        .ena(1'b1)
    );
endmodule
