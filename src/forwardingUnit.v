module forwardingUnit(
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,
    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,
    input ex_mem_wb,
    input mem_wb_wb,

    output reg [1:0] forward_A,
    output reg [1:0] forward_B
);

    // 00 -> The second ALU comes from the register file
    // 01 -> The second ALU operand is forwarded from data memory or an earlier ALU result
    // 10 -> The second ALU operand is forwarded from the prior ALU result

    always @(*) begin
        if(ex_mem_wb && ex_mem_rd != 0 && ex_mem_rd == id_ex_rs1) forward_A = 2'b10;
        else if(mem_wb_wb && mem_wb_rd != 0 && mem_wb_rd == id_ex_rs1) forward_A = 2'b01;
        else forward_A = 2'b00;

        if(ex_mem_wb && ex_mem_rd != 0 && ex_mem_rd == id_ex_rs2) forward_B = 2'b10;
        else if(mem_wb_wb && mem_wb_rd != 0 && mem_wb_rd == id_ex_rs2) forward_B = 2'b01;
        else forward_B = 2'b00;
    end

endmodule