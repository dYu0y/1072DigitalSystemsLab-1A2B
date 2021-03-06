module Guess(clk, in, seg_out, led_out);
	input clk;
	input[0:12] in;
	output reg[0:31] seg_out;
	output reg[0:9] led_out;
	
	reg[3:0] hp_v, sel_num_sig;
	reg[5:0] title_delay;
	reg[9:0] hp;
	reg[15:0] val_out, ans, guess_num;
	wire[7:0] seg0, seg1, seg2, seg3;
	wire clk_1ms, clk_1, clk_rnd;
	wire[15:0] randnum, check_res;
	
	BCD_to_seg(val_out[15:12], seg0, sel_num_sig[3]);
	BCD_to_seg(val_out[11:8], seg1, sel_num_sig[2]);
	BCD_to_seg(val_out[7:4], seg2, sel_num_sig[1]);
	BCD_to_seg(val_out[3:0], seg3, sel_num_sig[0]);
	clock_ (clk, clk_1, 250);
	clock_ (clk, clk_rnd, 10);
	clock_ (clk, clk_display, 16);
	randGen(clk_rnd, randnum);
	checker(ans, guess_num, check_res);
	
	parameter s_init = 4'd0, s_input = 4'd1, s_show = 4'd2, s_end = 4'd3, s_win = 4'd4, s_lose = 4'd5;
	reg[3:0] state;
	wire mode;

	reg[2:0] sel_num;
	
	assign mode = in[9];
	
	initial begin
		hp_v = 10;
		hp = 10'h3ff;
		guess_num = 0;
		ans = randnum;
		sel_num = 0;
		sel_num_sig = 4'b0111;
		title_delay = 0;
		
		val_out = 16'h1a2b;
		state = s_init;
	end
	
	always@(posedge clk_1/*negedge in[10] or negedge in[11] or negedge in[12] or negedge mode*/) begin
		if(~mode) begin
			case(state)
				s_init: begin
					hp_v = 10;
					hp = 10'h3ff;
					guess_num = 0;
					ans = randnum;
					sel_num = 0;
					sel_num_sig = 4'b0111;
					
					val_out = 16'h1a2b;
					if(title_delay == 15 || ~in[11]) begin
						state = s_input;
						title_delay = 0;
					end
					else
						title_delay = title_delay + 1;
				end
				s_input: begin
					if(~in[10])
						case(sel_num)
							0: begin
								if(guess_num[15:12] == 9)
									guess_num[15:12] = 0;
								else
									guess_num[15:12] = guess_num[15:12] + 1;
							end
							1: begin
								if(guess_num[11:8] == 9)
									guess_num[11:8] = 0;
								else
									guess_num[11:8] = guess_num[11:8] + 1;
							end
							2: begin
								if(guess_num[7:4] == 9)
									guess_num[7:4] = 0;
								else
									guess_num[7:4] = guess_num[7:4] + 1;
							end
							3: begin
								if(guess_num[3:0] == 9)
									guess_num[3:0] = 0;
								else
									guess_num[3:0] = guess_num[3:0] + 1;
							end
						endcase
					if(~in[11]) begin
						if(sel_num == 3)
							sel_num = 0;
						else
							sel_num = sel_num + 1;
						sel_num_sig = {sel_num_sig[0],sel_num_sig[3:1]};
					end
					if(~in[12]) begin
						state = s_show;
						if(check_res[15:12] != 4) begin
							if(hp_v > 0) begin
								if(hp_v == 1)
									state = s_lose;
								hp_v = hp_v - 1;
								hp = hp >> 1;
							end
						end
						else
							state = s_win;
					end
					val_out = guess_num;
				end
				s_show: begin
					val_out = check_res;
					if(~in[11])
						state = s_input;
				end
				s_end: begin
				end
				s_win: begin
					if(!in[11])
						state = s_init;
				end
				s_lose: begin
					val_out = 16'hf05e;
					if(~in[11])
						state = s_init;
					if(~in[10])
						val_out = ans;
				end
				default: begin
				end
			endcase
		end
		else begin
			if(~in[10])
				state = s_init;
			if(~in[11])
				if(hp_v < 10)begin
					hp_v = hp_v + 1;
					hp = (hp << 1) + 1;
				end
			if(~in[12])
				val_out = ans;
		end
	end
	
	always@(posedge clk_display) begin
		seg_out = {seg0,seg1,seg2,seg3};
		if(state == s_win)
			led_out = {led_out[1:9],led_out[0]};
		else
			led_out = hp;
	end
endmodule

