module Multiplicand(input Reset, input [31:0] Multiplicand_in, 
					output reg [31:0]Multiplicand_out);
	assign Multiplicand_out = (Reset == 1) ? Multiplicand_in : Multiplicand_out;
endmodule

