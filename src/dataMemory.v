module dataMemory( input clock,
					input mem_read,
					input mem_write,
					input[63:0] address,
					input[63:0] write_data,
					output [63:0] read_data);

	reg [63:0] memory [127:0];
	
	assign read_data = mem_read ? memory[address[63:3]] : 0;
	
	initial begin
		$readmemb("inputs/data", memory);
	end
	
	always @(posedge clock) begin
		if (mem_write == 1) begin
			memory[address[63:3]] <= write_data;
		end
	end
endmodule
