/*
 *	Template for Project 3 Part 1
 *	Copyright (C) 2025 Xi Zhu Wang or any person belong ESSLab.
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
module FinalCPU(
	output        PC_Write,
	// Outputs
	output [31:0] Output_Addr,
	// Inputs
	input  [31:0] Input_Addr,
	input         clk
);
	//pipline
	wire [29:0] stage1_output;
	wire [101:0] stage2_output;
	wire [71:0] stage3_output;
	wire [37:0] stage4_output;//{WB:37, ALU_result:[36:5], RdAddr:[4:0]}
	//stage1 input
	wire [31:0] instruction_wire;
	//stage2 input
	wire [31:0] RsData_wire, RtData_wire;
	wire [6:0] control_signal_bus; //{ALU_OP, Reg_Dst, Reg_w, ALU_src, Mem_to _reg, Mem_w}
	//stage3 input
	wire [31:0] ALU_result_wire;
	// in stage 1
	wire stall_control_wire;
	wire [6:0] control_signal_bus_in;
	//in stage 2
	wire [1:0] func_wire;
	wire [4:0] Reg_dst_wire;
	wire [31:0] ALU_Src1_wire;
	wire [31:0] ALU_Src2_wire;
	wire [31:0] ALU_Src2_wire_reg;
	wire [1:0] Forward_Src1_wire;
	wire [1:0] Forward_Src2_wire;
	//in stage 3
	wire [31:0] DM_out_wire;
	//in stage 4
	wire [31:0] Reg_WB_wire;
	assign control_signal_bus_in = (stall_control_wire) ? 7'b0 : control_signal_bus;
	assign ALU_Src1_wire = (Forward_Src1_wire == 2'b00) ? stage2_output[94:63] :
						   (Forward_Src1_wire == 2'b01) ? Reg_WB_wire:
						   (Forward_Src1_wire == 2'b10) ? stage3_output[68:37] : 32'b?;
	assign ALU_Src2_wire_reg = (Forward_Src2_wire == 2'b00) ? stage2_output[62:31] :
						       (Forward_Src2_wire == 2'b01) ? Reg_WB_wire:
						       (Forward_Src2_wire == 2'b10) ? stage3_output[68:37] : 32'b?;

	assign ALU_Src2_wire = (stage2_output[98]) ? {16'b0, stage2_output[30:15]} : ALU_Src2_wire_reg;
	assign Reg_dst_wire = (stage2_output[95]) ?  {stage2_output[9:5]} : {stage2_output[14:10]};
	assign Reg_WB_wire = stage4_output[36:5];
	assign PC_Write = ~stall_control_wire;

	Control Controller(
		.OpCode(stage1_output[29:26]),
		.Mem_to_reg(control_signal_bus[6]),
		.Reg_w(control_signal_bus[5]),
		.Mem_w(control_signal_bus[4]),
		.ALU_src(control_signal_bus[3]),
		.ALU_OP(control_signal_bus[2:1]),
		.Reg_Dst(control_signal_bus[0])
	);

	Hazard_detection Hazard_detection_unit(
		.Mem_write(stage2_output[101]),
		.RsAddr(stage1_output[25:21]),
		.RtAddr(stage1_output[20:16]),
		.RdAddr(stage2_output[14:10]),
		.stall_control(stall_control_wire)
	);
	Forwarding Forwarding_unit (
		.RsAddr(stage2_output[4:0]),
		.RtAddr(stage2_output[14:10]),
		.RdAddr_stage3(stage3_output[4:0]),
		.Reg_w_stage3(stage3_output[70]),
		.RdAddr_stage4(stage4_output[4:0]),
		.Reg_w_stage4(stage4_output[37]),
		.Forward_Src1(Forward_Src1_wire),
		.Forward_Src2(Forward_Src2_wire)
	);

	pipline_register_1 pipline_register_1(
		.instruction(instruction_wire[29:0]),
		.stall(stall_control_wire),
		.clk(clk),
		.stage1(stage1_output)
	);
	pipline_register_2 pipline_register_2(
		.input_bus({control_signal_bus_in, RsData_wire, RtData_wire, stage1_output[15:0], 
					stage1_output[20:16], stage1_output[15:11], stage1_output[25:21]}),
		.clk(clk),
		.stage2(stage2_output)
	);
	pipline_register_3 pipline_register_3(
		.input_bus({stage2_output[101:99], ALU_result_wire, ALU_Src2_wire_reg, Reg_dst_wire}),
		.stage3(stage3_output),
		.clk(clk)
	);
	wire [31:0] stage4_pre_process = (stage3_output[71]) ? DM_out_wire:stage3_output[68:37];
	pipline_register_4 pipline_register_4(
		.input_bus({stage3_output[70], stage4_pre_process, stage3_output[4:0]}),
		.stage4(stage4_output),
		.clk(clk)
	);

	ALU ALU(
		.Src1(ALU_Src1_wire),
		.Src2(ALU_Src2_wire),
		.shift(stage2_output[25:21]),
		.func(func_wire),
		.Result(ALU_result_wire)
	);
	ALU_control ALU_control(
		.funct_ctrl(stage2_output[17:15]),
		.ALU_OP(stage2_output[97:96]),
		.ALU_function(func_wire)
	);
	/* 
	 * Declaration of Instruction Memory.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	IM Instr_Memory(
		.Instr(instruction_wire),
		.InstrAddr(Input_Addr)
	);

	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	RF Register_File(
		//input
		.RsAddr(stage1_output[25:21]),
		.RtAddr(stage1_output[20:16]),
		.RdAddr(stage4_output[4:0]),
		.RdData(Reg_WB_wire),
		.RegWrite(stage4_output[37]),
		.clk(clk),
		//output
		.RsData(RsData_wire), /////////////////////////////
		.RtData(RtData_wire) /////////////////////////////
	);
	DM Data_Memory(
		.MemReadData(DM_out_wire),
		.MemAddr(stage3_output[68:37]), //.MemAddr({27'b0,stage3_output[41:37]}),
		.MemWriteData(stage3_output[36:5]),
		.MemWrite(stage3_output[69]),
		.clk(clk)
	);
	Adder Adder(
		.Src1(Input_Addr),
		.Result(Output_Addr)
	);
endmodule
