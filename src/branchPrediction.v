`include "immGenerator.v"

module branchPrediction (
    input clock,
    input isBranch,
    input lastBranchTaken,
    input lastBranchPrediction,
    input [63:0] currPcValue,
    input [63:0] lastPcValue,
    input [63:0] lastPcPlusImmediate,
    input [31:0] currInstruction,

    output reg [63:0] nextPcValue,
    output reg prediction,
    output reg flush
);

    reg [1:0] state;
    wire [63:0] immediate;

    immGenerator immGen(currInstruction, immediate);

    initial begin
        state = 0;
        nextPcValue = 0;
        prediction = 0;
        flush = 0;
    end

    always @(state) begin
        if(state == 2'b00) prediction = 0;
        if(state == 2'b11) prediction = 1;
    end

    always @(*) begin
        if(isBranch && lastBranchPrediction != lastBranchTaken) begin
            if(lastBranchTaken) begin
                nextPcValue = lastPcPlusImmediate;
            end else begin
                nextPcValue = lastPcValue + 4;
            end
            flush = 1;
        end else begin
            if(currInstruction[6:0] == 7'b1100111 && prediction) begin
                nextPcValue = currPcValue + (immediate << 1);
            end else begin
                nextPcValue = currPcValue + 4;
            end
            flush = 0;
        end
    end

    always @(posedge clock) begin
        if(isBranch) begin
            state[1] <= state[0];
            state[0] <= lastBranchTaken;
        end
    end

endmodule