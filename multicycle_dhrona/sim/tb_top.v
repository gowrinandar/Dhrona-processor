module tb_top();
    reg clk, reset;
    wire halt;
    wire [7:0] o_p;
    
    top dut(.clk(clk),
            .reset(reset),
            .halt(halt),
            .o_p(o_p)
            );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        
        #500000;
        $display("TIMEOUT");
        $display("Final: r0=%0d, r1=%0d, r2=%0d, r3=%0d",
                  dut.rf_inst.regs[0],
                  dut.rf_inst.regs[1],
                  dut.rf_inst.regs[2],
                  dut.rf_inst.regs[3]);
        $finish;
    end
    
    initial begin
        wait(dut.halt == 1);
        #10;
        $display("Simulation complete");
        $display("Got: r0=%0d, r1=%0d, r2=%0d, r3=%0d",
                  dut.rf_inst.regs[0],
                  dut.rf_inst.regs[1],
                  dut.rf_inst.regs[2],
                  dut.rf_inst.regs[3]);
        $finish;
    end
    
    initial begin
        $monitor("t=%0t | pc=%0d | if_id_instr=%h | decoded_rd=%0d | id_ex_rd=%0d | r0=%0d | r1=%0d | r2=%0d | r3=%0d | r4=%0d",
                  $time,
                  dut.pc_inst.pc_curr,
                  dut.if_id_inst.instr_out,
                  dut.id_inst.rd,
                  dut.id_ex_inst.rd_out,
                  dut.rf_inst.regs[0],
                  dut.rf_inst.regs[1],
                  dut.rf_inst.regs[2],
                  dut.rf_inst.regs[3],
                  dut.rf_inst.regs[4]
                  );
    end
    
endmodule