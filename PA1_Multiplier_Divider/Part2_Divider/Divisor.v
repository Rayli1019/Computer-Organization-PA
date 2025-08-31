module Divisor(input Reset, input [31:0] Divisor_in, 
	output wire [31:0] Divisor_out);
	assign Divisor_out  = (Reset == 1) ? Divisor_in : Divisor_out;
endmodule