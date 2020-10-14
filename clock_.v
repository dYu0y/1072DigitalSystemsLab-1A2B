module clock_(clk, clk_, period);
	input clk;
	input[15:0] period;
	output reg clk_;
	reg[31:0] counter, p;
	
	initial begin 
		counter = 0;
		clk_ = 0;
		p = 0;
	end
	
	always@(posedge clk) begin
		if(!p) p <= 25000 * period;
		else if(counter >= p) begin
			counter <= 0;
			clk_ <= ~clk_;
		end
		else
			counter <= counter + 1;
	end
endmodule
