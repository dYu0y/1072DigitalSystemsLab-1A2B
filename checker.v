module checker(ans, in, out);
	input[15:0] ans, in;
	output[15:0] out;
	reg[3:0] A, B;
	
	assign out = {A,4'ha,B,4'hb};
	
	always@(ans or in) begin
		A = (ans[15:12] == in[15:12]) + (ans[11:8] == in[11:8]) + (ans[7:4] == in[7:4]) + (ans[3:0] == in[3:0]);
		B = (ans[11:8] == in[15:12]) + (ans[7:4] == in[15:12]) + (ans[3:0] == in[15:12])
			+ (ans[15:12] == in[11:8]) + (ans[7:4] == in[11:8]) + (ans[3:0] == in[11:8])
			+ (ans[15:12] == in[7:4]) + (ans[11:8] == in[7:4]) + (ans[3:0] == in[7:4])
			+ (ans[15:12] == in[3:0]) + (ans[11:8] == in[3:0]) + (ans[7:4] == in[3:0]);
	end
endmodule
