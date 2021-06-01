`timescale 1ns / 100ps
`include "TP_03.v"

module testbench();

	reg clock;
	
	TP_03 riscv(clock, 1'b0);
	
	integer i;
	
	initial begin
		clock = 0;
		$dumpfile("testbench.vcd");
		$dumpvars;
		for(i=0; i<128; i=i+1) begin
			$dumpvars(2, riscv.DM.memory[i]);
		end
        for(i=0; i<32; i=i+1) begin
			$dumpvars(2, riscv.regs.regs[i]);
		end
		#900000 $finish;
	end

  always #10 clock = ~clock;
  
endmodule
