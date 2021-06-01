module mux2x1Control(input branch_in,
					input memRead_in,
					input memToReg_in,
					input memWrite_in,
					input [1:0] aluOp_in,
					input aluSRC_in,
					input regWrite_in,
                    input selector,
                    
                    output branch,
					output memRead,
					output memToReg,
					output [1:0] aluOp,
					output memWrite,
					output aluSRC,
					output regWrite
);


assign branch = selector ? branch_in : 0;
assign memRead = selector ? memRead_in : 0;
assign memToReg = selector ? memToReg_in : 0;
assign aluOp = selector ? aluOp_in : 0;
assign memWrite = selector ? memWrite_in : 0;
assign aluSRC = selector ? aluSRC_in : 0;
assign regWrite = selector ? regWrite_in : 0;

endmodule