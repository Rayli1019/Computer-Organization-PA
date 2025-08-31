/*
 *	Template for Project 2 Part 3
 *	Copyright (C) 2025 Xi-Zhu Wang or any person belong ESSLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1132 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module SimpleCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);

	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	wire [31:0] PC_plus_4;
	wire [31:0] instruction_wire;
	wire [31:0] RsData_wire, RtData_wire;
	wire [4:0] R_or_I_reg_wire;
	wire [31:0] Reg_write_back_wire;
	wire [31:0] Memory_out_wire, ALU_out_wire;
	wire Reg_dst_wire, Branch_wire, Reg_w_wire, ALU_src_wire, Mem_w_wire,
		Mem_r_wire, Mem_to_reg_wire, Jump_wire;
	wire [1:0] ALU_OP_wire;
	wire [1:0] ALU_funct_wire;
	wire zero_wire;
	wire [31:0] no_jump_addr;
	wire [31:0] sign_extend_wire;
	wire [31:0] PC_plus4_or_imj;
	wire [31:0] ALU_Src2;
	//assign sign_extend_wire = {{16{instruction_wire[15]}}, instruction_wire[15:0]};
	assign sign_extend_wire = {16'b0, instruction_wire[15:0]};
	assign R_or_I_reg_wire = (Reg_dst_wire) ? instruction_wire[15:11]:instruction_wire[20:16];
	assign PC_plus_4 = Input_Addr + 4;
	assign ALU_Src2 = (ALU_src_wire) ? sign_extend_wire : RtData_wire;
	assign PC_plus4_or_imj = (zero_wire && Branch_wire) ? no_jump_addr : PC_plus_4;
	assign Output_Addr = (Jump_wire) ? {PC_plus_4[31:26], instruction_wire[25:0], 2'b00}:PC_plus4_or_imj;
	assign Reg_write_back_wire = (Mem_to_reg_wire) ? Memory_out_wire:ALU_out_wire;
	IM Instr_Memory(
		.InstrAddr(Input_Addr),
		.Instr(instruction_wire)
	);
	
	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
		.RsAddr(instruction_wire[25:21]),
		.RtAddr(instruction_wire[20:16]),
		.RdAddr(R_or_I_reg_wire),
		.RegWrite(Reg_w_wire),
		.clk(clk),
		.RdData(Reg_write_back_wire),
		.RsData(RsData_wire),
		.RtData(RtData_wire)
	);
	
	/* 
	 * Declaration of Data Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	DM Data_Memory(
		.MemReadData(Memory_out_wire),
		.MemAddr(ALU_out_wire),
		.MemWriteData(RtData_wire),
		.MemWrite(Mem_w_wire),
		.MemRead(Mem_r_wire),
		.clk(clk)
	);
	
	Control Controller(
		.OPcode(instruction_wire[31:26]),
		.Reg_Dst(Reg_dst_wire),
		.Branch(Branch_wire),
		.Reg_w(Reg_w_wire),
		.ALU_OP(ALU_OP_wire),
		.ALU_src(ALU_src_wire),
		.Mem_w(Mem_w_wire),
		.Mem_r(Mem_r_wire),
		.Mem_to_reg(Mem_to_reg_wire),
		.jump(Jump_wire)
	);
	
	ALU_control ALU_Controller(
		.funct_ctrl(instruction_wire[5:0]),
		.ALU_OP(ALU_OP_wire),
		.ALU_function(ALU_funct_wire)
	);
	
	ALU ALU(
		.Src1(RsData_wire),
		.Src2(ALU_Src2),
		.Shift(instruction_wire[10:6]),
		.func(ALU_funct_wire),
		.Result(ALU_out_wire),
		.zero(zero_wire)
	);
	
	Adder_32bit Adder(
		.Src1(PC_plus_4),
		.Src2({sign_extend_wire[29:0], 2'b00}),
		.Result(no_jump_addr)
	);
	
	
endmodule
