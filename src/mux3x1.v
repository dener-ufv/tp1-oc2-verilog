module mux3x1 (
    input [63:0] in0,
    input [63:0] in1,
    input [63:0] in2,
    input [1:0] select,
    output [63:0] out0
);

    assign out0 = select == 2'b00 ? in0 : select == 2'b01 ? in1 : in2;

endmodule