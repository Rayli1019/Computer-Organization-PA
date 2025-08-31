module CompDivider(
	// Outputs
	output	[31:0]	Quotient,
	output	[31:0]	Remainder,
	output			Ready,
	// Inputs
	input	[31:0]	Dividend,
	input	[31:0]	Divisor,
	input			Run,
	input			Reset,
	input			clk
);
	wire wire_pre_finish;
	wire [31:0] wire_ALU_result;
	wire wire_ALU_carry;
	wire [31:0] wire_Remainder;
	wire temp;
	wire [31:0] wire_Divisor_out;
	assign Remainder = wire_Remainder;
	/*module Remainder(input pre_finish, input Reset, input clk, input Run, input [31:0] ALU_result,  
				input [31:0] Dividend_in, input ALU_carry, 
				output reg [63:0]Remainder_out);*/
	Remainder Remainder_block(
		.pre_finish(wire_pre_finish),
		.Reset(Reset),
		.clk(clk),
		.Run(Run),
		.ALU_result(wire_ALU_result),
		.Dividend_in(Dividend),
		.ALU_carry(wire_ALU_carry),
		.Remainder_out({temp, wire_Remainder, Quotient}),
		.Ready(Ready)
	);
	/*module Control(input Run, input Reset, input clk, output reg Ready, output reg pre_finish);*/
	Control Controller(
		.Run(Run),
		.Reset(Reset),
		.clk(clk),
		.Ready(Ready),
		.pre_finish(wire_pre_finish)
	);
	/*module Divisor(input Reset, input [31:0] Divisor_in, output wire [31:0] Divisor_out);*/
	Divisor Divisor_block(
		.Reset(Reset),
		.Divisor_in(Divisor),
		.Divisor_out(wire_Divisor_out)
	);
	/*module ALU(input [31:0] Src_1, input [31:0] Src_2, output wire Carry, output wire [31:0] Result);*/
	ALU ALU_block(
		.Src_1(wire_Remainder),
		.Src_2(wire_Divisor_out),
		.Carry(wire_ALU_carry),
		.Result(wire_ALU_result)
	);
endmodule

