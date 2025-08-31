module Remainder(input pre_finish, input Reset, input clk, input Ready, 
				input Run, input [31:0] ALU_result, input [31:0] Dividend_in,
				input ALU_carry, output reg [64:0]Remainder_out);
	always@(posedge clk) begin
		if(Reset == 1) begin
			Remainder_out <= {31'b0, Dividend_in, 1'b0};
		end
		else if(Run == 1 && pre_finish == 0) begin
			if(ALU_carry == 0) begin
				Remainder_out[64:32] <= {ALU_result[31:0], Remainder_out[31]};
				Remainder_out[31:0] <= {Remainder_out[30:0], 1'b1};
			end
			else begin
				Remainder_out[64:0] <= {Remainder_out[63:0], 1'b0};
			end
		end
		else if(pre_finish == 1 && Ready == 0) begin
			Remainder_out[63:32] <= Remainder_out[64:33];
		end
	end
endmodule


