module shiftLeft(    input [63:0] dataIn,
                        output  [63:0] dataOut);

	  assign dataOut[0] = 0;
	  assign dataOut[63:1] = dataIn[62:0];
    
endmodule
