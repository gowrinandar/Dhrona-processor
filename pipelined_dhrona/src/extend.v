module extend(
    input [4:0] imm,
    input [7:0] offset,
    output [15:0] imm_out,
    output [15:0] off_out
    );
    assign imm_out={{11{imm[4]}},imm};
    assign off_out={{8{offset[7]}},offset};
endmodule