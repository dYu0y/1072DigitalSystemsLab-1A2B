module BCD_to_seg(num, seg_out, dot);//transfer BCD to 7 segment output
	input[3:0] num;//BCD input
	input dot;
	output reg[0:7] seg_out;//7 segment output
	always@(num) begin
		case(num)
			0: seg_out = 8'b00000010 + dot;
			1: seg_out = 8'b10011110 + dot;
			2: seg_out = 8'b00100100 + dot;
			3: seg_out = 8'b00001100 + dot;
			4: seg_out = 8'b10011000 + dot;
			5: seg_out = 8'b01001000 + dot;
			6: seg_out = 8'b01000000 + dot;
			7: seg_out = 8'b00011110 + dot;
			8: seg_out = 8'b00000000 + dot;
			9: seg_out = 8'b00001000 + dot;
			10:seg_out = 8'b00010000 + dot;
			11:seg_out = 8'b11000000 + dot;
			14:seg_out = 8'b01100000 + dot;
			15:seg_out = 8'b11100010 + dot;
			default: seg_out = 8'b00110000;
		endcase
	end
endmodule
