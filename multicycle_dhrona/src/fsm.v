module fsm(
    input clk,
    input reset,
    input [4:0] opcode,
    output reg ir_we,//instruction register write enable
    output reg pc_write,//pc write enable
    output reg reg_write,//registerfile write enable
    output reg mem_write,//data_memory write enable
    output reg a_we,//latches rs1 to register a
    output reg b_we,//latches rs2 to register b
    output reg aluout_we,//alu output register latch
    output reg mdr_we,//memory data register enable
    output reg mem_to_reg,//write_back enable
    output reg alu_src,//controls mux to decide whether to choose rs2 or immediate value
    output reg load_src,//controls mux to decide whether to choose reg a or offset for load instruction
    output reg halt,//halts the processor when HLT instruction is encountered
    output reg flag_we//works as the enable for the flag module
);

    localparam FETCH_WAIT=3'b101, FETCH=3'b000, DECODE=3'b001, EXECUTE=3'b010, MEMORY=3'b011, WRITEBACK=3'b100;
    reg [2:0] state;
    always@(posedge clk or posedge reset) begin
        if(reset)
            state <= FETCH_WAIT;
        else if(!halt) begin
            case(state)
                FETCH_WAIT: state <= FETCH;
                FETCH:      state <= DECODE;
                DECODE:     state <= EXECUTE;
                EXECUTE:    state <= MEMORY;
                MEMORY:     state <= WRITEBACK;
                WRITEBACK:  state <= FETCH_WAIT;
                default:    state <= FETCH_WAIT;
            endcase
        end
    end
    
    always@(*) begin
    
    ir_we      = 0;
    pc_write   = 0;//when pc_write changes, pc of next gets latched and memory fetches
    reg_write  = 0;
    mem_write  = 0;
    a_we       = 0;
    b_we       = 0;
    aluout_we  = 0;
    mdr_we     = 0;
    mem_to_reg = 0;
    alu_src    = 0;
    load_src   = 0;
    halt       = 0;
    flag_we    = 0;
    
    case(state) 
    FETCH_WAIT: begin
            // wait for BRAM output, no control signals
        end
        
    FETCH: begin
        ir_we=1;
       // pc_write=1;
    end
    DECODE: begin
        a_we=1;
        b_we=1;
    end
    EXECUTE: begin
        aluout_we=1;
        if(opcode >= 5'b01100 && opcode <= 5'b10011)//immediate type
                alu_src = 1;
        if(opcode == 5'b10100)//load address comes from offset not reg
                load_src = 1;
        if(opcode == 5'b10101)//store takes address like load itself ie using offsets
                load_src = 1;
        if(opcode >= 5'b10110 && opcode <= 5'b11100)//branches 
                pc_write = 1;
        if(opcode <= 5'b01011 || 
        (opcode >= 5'b01100 && opcode <= 5'b10011))
            flag_we = 1;  // register and immediate type instructions set flags
    end
    MEMORY: begin
            if(opcode == 5'b10101)// store
                mem_write = 1;
            if(opcode == 5'b10100)// load
                mdr_we = 1;
    end
    WRITEBACK: begin
          if((opcode < 5'b10110 || opcode > 5'b11100) && opcode != 5'b11111)
                pc_write = 1;  // pc updates only in the writeback stage 
            if(opcode == 5'b11111) begin
                halt = 1;
            end
            else if(opcode == 5'b10101 ||(opcode >= 5'b10110 && opcode <= 5'b11100))// branches and load
                reg_write = 0;
            else begin
                reg_write = 1;
                if(opcode == 5'b10100)  // load gets data from MDR
                    mem_to_reg = 1;
            end
        end
    endcase
    end
endmodule