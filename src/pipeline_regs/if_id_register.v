module if_id_register (
    input clk,
    input [63:0] pc,
    input [31:0] instruction,
    input flush,
    input if_write,
    input prediction,
    
    output reg [63:0] pc_reg,
    output reg [31:0] instruction_reg,
    output reg prediction_reg
);

    initial begin
        pc_reg = 0;
        instruction_reg = 0; 
    end
    
    always @(posedge clk) begin
        if (flush) begin
            instruction_reg <= 0;
        end else if(if_write) begin
            pc_reg <= pc;
            instruction_reg <= instruction;
        end
        prediction_reg <= prediction;
    end
    
endmodule