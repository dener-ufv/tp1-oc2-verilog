module aluControl(	input [1:0] ALUOp,
					input [6:0] funct7,
					input [2:0] funct3,
					output reg [3:0] ALUCtl);

	wire [11:0] concat;
	assign concat = {ALUOp, funct7, funct3};

	always @(*) begin
		casex(concat)
			12'b00xxxxxxxxxx: ALUCtl <= 4'b0010;
			12'b01xxxxxxxxxx: ALUCtl <= 4'b0110;
			12'b100000000000: ALUCtl <= 4'b0010;
			12'b100100000000: ALUCtl <= 4'b0110;
			12'b100000000111: ALUCtl <= 4'b0000;
			12'b100000000110: ALUCtl <= 4'b0001;
			default         : ALUCtl <= 4'b1111;
		endcase
	end
endmodule
