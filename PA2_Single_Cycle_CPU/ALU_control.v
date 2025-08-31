`define ADD_FUNC 2'b00
`define SUB_FUNC 2'b01
`define OR_FUNC 2'b10
`define FUNC_FUNC 2'b11

`define ADD 2'b00
`define SUB 2'b01
`define OR_OP 2'b10
`define SHIFT_OP 2'b11

`define addr 3'b001
`define subr 3'b011
`define shiftr 3'b000
`define orr 3'b101
module ALU_control(
    input [5:0] funct_ctrl, 
    input [1:0] ALU_OP, 
    output reg [1:0] ALU_function
);

    // 定義功能碼
	
	always@(*) begin
		if(ALU_OP == `FUNC_FUNC) begin
			case(funct_ctrl[2:0])
				`addr: begin
					ALU_function <= `ADD;
				end
				`subr: begin
					ALU_function <= `SUB;
				end
				`shiftr: begin
					ALU_function <= `SHIFT_OP;
				end
				`orr: begin
					ALU_function <= `OR_OP;
				end
			endcase
		end
		else if(ALU_OP == `ADD_FUNC) begin
			ALU_function <= `ADD;
		end
		else if(ALU_OP == `SUB_FUNC) begin
			ALU_function <= `SUB;
		end
		else if(ALU_OP == `OR_FUNC) begin
			ALU_function <= `OR_OP;
		end
		else begin
			ALU_function <= 2'b??;
		end
	end
endmodule