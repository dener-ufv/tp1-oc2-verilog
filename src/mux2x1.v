module mux2x1(	input [63:0] in0,
	 		input [63:0] in1,
			input sel,
			output [63:0] data);


	assign data = (sel ? in1 : in0);

endmodule
