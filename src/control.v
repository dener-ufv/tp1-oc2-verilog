module control(input [6:0] instruction,
					output reg branch,
					output reg memRead,
					output reg memToReg,
					output reg [1:0] aluOp,
					output reg memWrite,
					output reg aluSRC,
					output reg regWrite);
					
	always @(*) begin
		case(instruction[6:0])
			7'b0000011 :begin // ld
				branch = 0;
				memRead = 1;
				memToReg = 1;
				aluOp[1:0] = 2'b00 ;
				aluSRC = 1;
				regWrite = 1;
				memWrite = 0;	
				end
				
			7'b0100011 :begin // sd
				branch = 0;
				memRead = 0; 
				memToReg = 0; 
				aluOp[1:0] = 2'b00 ;
				aluSRC = 1;
				regWrite = 0;
				memWrite = 1;
				end
				
			7'b1100111 :begin // beq
				branch = 1;
				memRead = 0; 
				memToReg = 0; 
				aluOp[1:0] = 2'b01;
				aluSRC = 0;
				memWrite = 0;
				regWrite = 0;
				end
			
			7'b0110011 : begin // or || and || add || sub
				branch = 0;
				memRead = 0;
				memToReg = 0;
				aluOp[1:0] <= 2'b10 ;
				aluSRC = 0;
				memWrite = 0;
				regWrite = 1;
				end
				
			default:begin
				branch = 0;
				memRead = 0; 
				memToReg = 0; 
				aluOp <= 0;
				aluSRC = 0;
				memWrite = 0;
				regWrite = 0;
				end 
		endcase
	end

endmodule
