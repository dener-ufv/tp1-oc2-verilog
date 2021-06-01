module id_ex_register (
    input clk,
    input [63:0] pc,
    input [63:0] rd1_in,
    input [63:0] rd2_in,
    input [4:0] if_id_rs1_in,
    input [4:0] if_id_rs2_in,
    input [4:0] if_id_rd_in,
    input [63:0] immediate,
    input [6:0] funct7,
    input [2:0] funct3,
    input branch,
    input memRead,
    input memToReg,
    input [1:0] aluOp,
    input memWrite,
    input aluSRC,
    input regWrite,
    input flush,
    input prediction,

    output reg [63:0] pc_reg,
    output reg [63:0] rd1,
    output reg [63:0] rd2,
    output reg [63:0] immediate_reg,
    output reg [6:0] funct7_reg,
    output reg [2:0] funct3_reg,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg branch_reg,
    output reg memRead_reg,
    output reg memToReg_reg,
    output reg [1:0] aluOp_reg,
    output reg memWrite_reg,
    output reg aluSRC_reg,
    output reg regWrite_reg,
    output reg prediction_reg
);

    initial begin
        pc_reg = 0;
        rd1 = 0;
        rd2 = 0;
        immediate_reg = 0;
        funct7_reg = 0;
        funct3_reg = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        branch_reg = 0;
        memRead_reg = 0;
        memToReg_reg = 0;
        aluOp_reg = 0;
        memWrite_reg = 0;
        aluSRC_reg = 0;
        regWrite_reg = 0;
        prediction_reg = 0;
    end

    always @(posedge clk) begin
        if (flush) begin
            branch_reg <= 0;
            memRead_reg <= 0;
            memToReg_reg <= 0;
            aluOp_reg <= 2'b0;
            memWrite_reg <= 0;
            aluSRC_reg <= 0;
            regWrite_reg <= 0;            
        end else begin
            branch_reg <= branch;
            memRead_reg <= memRead;
            memToReg_reg <= memToReg;
            aluOp_reg <= aluOp;
            memWrite_reg <= memWrite;
            aluSRC_reg <= aluSRC;
            regWrite_reg <= regWrite;
        end
        pc_reg <= pc;
        rd1 <= rd1_in;
        rd2 <= rd2_in;
        rs1 <= if_id_rs1_in;
        rs2 <= if_id_rs2_in;
        rd <= if_id_rd_in;
        immediate_reg <= immediate;
        funct7_reg <= funct7;
        funct3_reg <= funct3;
        prediction_reg <= prediction;
    end
    
endmodule