`define branch_op 4'b0100
`define jump_op 4'b0010
`define ori_op 4'b1101
`define lw_op 4'b0011
`define sw_op 4'b1011
`define addi_op 4'b1001
`define R_TYPE_op 4'b0000

`define ADD_FUNC 2'b00
`define SUB_FUNC 2'b01
`define OR_FUNC 2'b10
`define FUNC_FUNC 2'b11

module Control(
    input [5:0] OPcode,
    output reg Reg_Dst,
    output reg Branch,
    output reg Reg_w,
    output reg [1:0] ALU_OP,
    output reg ALU_src,
    output reg Mem_w,
    output reg Mem_r,
    output reg Mem_to_reg,
    output reg jump
);

	always@(*) begin
		if(OPcode[3:0] == `R_TYPE_op) begin
			Reg_Dst = 1;
			Branch = 0;
			Reg_w = 1;
			ALU_OP = `FUNC_FUNC;
			ALU_src = 0;
			Mem_r = 1;
			Mem_to_reg = 0;
			Mem_w = 0;
			jump = 0;
		end
		else if(OPcode[3:0] == `addi_op) begin
			Reg_Dst = 0;
			Branch = 0;
			Reg_w = 1;
			ALU_OP = `ADD_FUNC;
			ALU_src = 1;
			Mem_r = 1;
			Mem_to_reg = 0;
			Mem_w = 0;
			jump = 0;
		end
		else if(OPcode[3:0] == `sw_op) begin
			Reg_Dst = 0;
			Branch = 0;
			Reg_w = 0;
			ALU_OP = `ADD_FUNC;
			ALU_src = 1;
			Mem_r = 1;
			Mem_to_reg = 1'b?;
			Mem_w = 1;
			jump = 0;
		end
		else if(OPcode[3:0] == `lw_op) begin
			Reg_Dst = 0;
			Branch = 0;
			Reg_w = 1;
			ALU_OP = `ADD_FUNC;
			ALU_src = 1;
			Mem_r = 1;
			Mem_to_reg = 1;
			Mem_w = 0;
			jump = 0;
		end
		else if(OPcode[3:0] == `ori_op) begin
			Reg_Dst = 0;
			Branch = 0;
			Reg_w = 1;
			ALU_OP = `OR_FUNC;
			ALU_src = 1;
			Mem_r = 1;
			Mem_to_reg = 0;
			Mem_w = 0;
			jump = 0;
		end
		else if(OPcode[3:0] == `jump_op) begin
			Reg_Dst = 0;
			Branch = 0;
			Reg_w = 0;
			ALU_OP = 3'b???;
			ALU_src = 1'b?;
			Mem_r = 1;
			Mem_to_reg = 1'b?;
			Mem_w = 0;
			jump = 1;
		end
		else if(OPcode[3:0] == `branch_op) begin
			Reg_Dst = 0;
			Branch = 1;
			Reg_w = 0;
			ALU_OP = `SUB_FUNC;
			ALU_src = 1'b0;
			Mem_r = 1;
			Mem_to_reg = 1'b?;
			Mem_w = 0;
			jump = 0;
		end
		else begin
			Reg_Dst = 1'b?;
			Branch = 1'b0;
			Reg_w = 1'b0;
			ALU_OP = 3'b?;
			ALU_src = 1'b0;
			Mem_r = 1;
			Mem_to_reg = 1'b?;
			Mem_w = 1'b0;
			jump = 1'b0;
		end
	end
endmodule
