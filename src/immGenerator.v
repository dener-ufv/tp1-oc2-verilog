module immGenerator(
             input [31:0] instruction,
             output reg [63:0] immediate);

    integer i;
	
	always @(*) begin
	
		case(instruction[6:0])
			7'b0000011 : immediate[11:0] = instruction[31:20];
			7'b0100011 : 
				begin
					immediate[11:5] = instruction[31:25];
					immediate[4:0] = instruction[11:7];
				end
			7'b1100111 : begin
					immediate[11] = instruction[31];
					immediate[9:4] = instruction[30:25];
					immediate[3:0] = instruction[11:8];
					immediate[10] = instruction[7];
			end
			default:immediate[63:0]=0;
		endcase
		
		for (i = 12 ; i < 64; i = i + 1)
             immediate[i] = instruction[31];
				
	end
endmodule
