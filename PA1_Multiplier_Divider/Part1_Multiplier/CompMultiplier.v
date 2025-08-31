module CompMultiplier(
	// Outputs
	output 	[63:0]	Product,
	output		Ready,
	// Inputs
	input	[31:0]	Multiplicand,
	input	[31:0]	Multiplier,
	input		Run,
	input		Reset,
	input		clk
);
	wire [31:0] wire_Multiplicand;
	wire wire_ALU_carry;
	wire [31:0] wire_ALU_result;
	wire wire_Ready;
	wire [63:0] wire_Product;
	wire wire_pre_finish;
	assign Ready = wire_Ready;
	wire wire_add_flag;
	assign Product = wire_Product;
	//module Multiplicand(input clk, input Reset, input [31:0] Multiplicant_in, output reg [31:0]Multiplicant_out);
	Multiplicand Multiplicand_Block(
		.Reset(Reset),
		.Multiplicand_in(Multiplicand),
		.Multiplicand_out(wire_Multiplicand)
	);
	/*
	module Product(input [31:0]Multiplier_in, input ALU_carry, input [31:0] ALU_result, input Reset, input clk, input Run, input Ready,
			,output reg [63:0] Product);*/
			
	Product Product_block(
		.Multiplier_in(Multiplier),
		.ALU_carry(wire_ALU_carry),
		.ALU_result(wire_ALU_result),
		.Reset(Reset),
		.Run(Run),
		.Ready(wire_Ready),
		.Product(wire_Product),
		.clk(clk),
		.pre_finish(wire_pre_finish),
		.add_flag(wire_add_flag)
	);
	//module Control(input Run, input Reset, input clk, output reg Ready);
	Control Controller(
		.Run(Run),
		.Reset(Reset),
		.clk(clk),
		.Ready(wire_Ready),
		.pre_finish(wire_pre_finish)
	);
	//module ALU(input [31:0] Src_1, input [31:0] Src_2, output Carry, output [31:0] Result);
	ALU ALU_block(
		.Src_1(wire_Multiplicand),
		.Src_2(wire_Product[63:32]),
		.Carry(wire_ALU_carry),
		.Result(wire_ALU_result)
	);
endmodule

