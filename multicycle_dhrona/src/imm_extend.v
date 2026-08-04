module imm_extend(
    input [4:0] imm,
    output [15:0] imm_out
    );
    assign imm_out={{11{imm[4]}},imm};
    //will only work with values less than 15 as sign extension will go wrong beyond that
endmodule