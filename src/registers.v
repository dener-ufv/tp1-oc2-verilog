module registers(	input clock,
						input regWrite,
						input [4:0] rs1,
						input [4:0] rs2,
						input [4:0] wr,
						input [63:0] wdata,
						output [63:0] rd1,
						output [63:0] rd2);
						
	reg [63:0] regs [31:0];
	assign rd1 = (regWrite && wr == rs1) ? wdata : regs[rs1];
	assign rd2 = (regWrite && wr == rs2) ? wdata : regs[rs2];
	
	initial begin
		$readmemb("inputs/registers", regs);
	end
	
	always @(posedge clock) begin
		if(regWrite == 1 && wr != 0) begin
			regs[wr] <= wdata;
		end
	end
	
endmodule
	