module clockDivider(	input clockIn,
							output clockOut);

	reg [3:0] counter;
	
	initial begin
		counter = 0;
	end
	
	assign clockOut = counter[2];
	
	always @(posedge clockIn) begin
		counter <= counter + 4'd1;
	end
							
endmodule
