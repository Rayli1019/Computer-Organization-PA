`define ori_op 4'b1101
`define lw_op 4'b0011
`define sw_op 4'b1011
`define addi_op 4'b1001
`define R_TYPE_op 4'b0000

`define R_type 2'b00
`define ADD 2'b01
`define SUB 2'b10
`define OR 2'b11
/*
ALU_OP, Reg_Dst, Reg_w, ALU_src, Mem_to_reg, Mem_w, Mem_r
*/

module Control(
    input wire [3:0] OpCode,
    output reg [1:0] ALU_OP,
    output reg Reg_Dst,
    output reg Reg_w,
    output reg ALU_src,
    output reg Mem_to_reg,
    output reg Mem_w
);

    always@(*) begin
        if(OpCode == `R_TYPE_op) begin
            Reg_Dst = 1;
			Reg_w = 1;
			ALU_OP = `R_type;
			ALU_src = 0;
			Mem_to_reg = 0;
			Mem_w = 0;
        end
        else if(OpCode == `addi_op) begin
            Reg_Dst = 0;
			Reg_w = 1;
			ALU_OP = `ADD;
			ALU_src = 1;
			Mem_to_reg = 0;
			Mem_w = 0;
        end
        else if(OpCode == `sw_op) begin
            Reg_Dst = 0;
			Reg_w = 0;
			ALU_OP = `ADD;
			ALU_src = 1;
			Mem_to_reg = 0;
			Mem_w = 1;
        end
        else if(OpCode == `lw_op) begin
			Reg_Dst = 0;
			Reg_w = 1;
			ALU_OP = `ADD;
			ALU_src = 1;
			Mem_to_reg = 1;
			Mem_w = 0;
		end
        else if(OpCode == `ori_op) begin
			Reg_Dst = 0;
			Reg_w = 1;
			ALU_OP = `OR;
			ALU_src = 1;
			Mem_to_reg = 0;
			Mem_w = 0;
		end
        else begin
            Reg_Dst = 1'b?;
			Reg_w = 0;
			ALU_OP = 2'b?;
			ALU_src = 1'b?;
			Mem_to_reg = 1'b?;
			Mem_w = 0;
        end
    end
endmodule

/*
 /*
        case(OPcode)
            `R_TYPE_op: begin
                control_bus = {`R_type, 1, 1, 0, 0, 0, 1};
            end
            `addi_op: begin
                control_bus = {`ADD, 0, 1, 1, 0, 0, 1};
            end
            `sw_op: begin
                control_bus = {`ADD, 0, 0, 1, 0, 1, 1};
            end
            `lw_op: begin
                control_bus = {`ADD, 0, 1, 1, 1, 0, 1};
            end
            `ori: begin
                control_bus = {`OR, 0, 1, 1, 0, 0, 1};
            end
            else begin
                control_bus = {2'b?, 1'b?, 1'b0, 1'b?, 1'b?, 1'b0, 1};
            end
        endcase*/
