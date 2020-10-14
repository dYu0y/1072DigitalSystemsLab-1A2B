module randGen(clk, nums);
	input clk;
	output reg[15:0] nums;
	
	reg[79:0] arr1, arr2;
	reg[3:0] i, v;
	
	initial begin
		arr2 = 80'h00000000001736048295;
		nums = 16'h8763;
		i = 0;
		v = 0;
	end
	
	always@(posedge clk) begin
		if(i == 0) begin
			nums <= arr2[15:0];
			if(v == 7) begin
				i <= nums[3:0];
				v <= 2;
			end
			else begin
				v <= v + 1;
			end
			i <= v;
			arr1 <= arr2 << (v * 4);
		end
		else begin
			arr2 <= (arr2 << 4) + arr1[43:40];
			arr1 <= arr1 >> 4;
			i <= i - 1;
		end
	end
endmodule
