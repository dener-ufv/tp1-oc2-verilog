module alu(	input [63:0] data1,
					input [63:0] data2,
					input [3:0] op,
					output zero, 
					output reg [63:0] result);

	assign zero = (result == 0);
	
	always@(*) begin 
		case(op)
			4'b0000 : result <= data1 & data2;
			4'b0001 : result <= data1 | data2;
			4'b0010 : result <= data1 + data2;
			4'b0110 : result <= data1 - data2;
			default : result <= 64'b0;
		endcase
	end
					
endmodule
