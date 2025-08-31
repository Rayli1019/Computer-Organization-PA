`define ADD 2'b00
`define SUB 2'b01
`define OR_OP 2'b10
`define SHIFT_OP 2'b11
module ALU(
    input [31:0] Src1, 
    input [31:0] Src2, 
    input [4:0] Shift, 
    input [1:0] func, 
    output reg [31:0] Result,
	output reg zero
);
	//parameter `ADD = 0, `SUB = 1, `OR_OP = 2, `SHIFT_OP = 3;
	
	reg [8:0] Carry_internal;
	wire [31:0] Sum;
	reg [31:0] ADD_SUB_Src2;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : CLA4_BLOCK
            wire [3:0] A = Src1[i*4 +: 4];
            wire [3:0] B = ADD_SUB_Src2[i*4 +: 4];
            wire [3:0] G, P, C;

            assign G = A & B;
            assign P = A ^ B;

            assign C[0] = Carry_internal[i];
            assign C[1] = G[0] | (P[0] & C[0]);
            assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
            assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
            assign Carry_internal[i+1] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) |
                                         (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
            assign Sum[i*4 +: 4] = P ^ C;
        end
    endgenerate
	
	wire [31:0] shift_stage1 = Shift[0] ? (Src1 << 1)  : Src1;
    wire [31:0] shift_stage2 = Shift[1] ? (shift_stage1 << 2)  : shift_stage1;
    wire [31:0] shift_stage3 = Shift[2] ? (shift_stage2 << 4)  : shift_stage2;
    wire [31:0] shift_stage4 = Shift[3] ? (shift_stage3 << 8)  : shift_stage3;
    wire [31:0] shift_stage5 = Shift[4] ? (shift_stage4 << 16) : shift_stage4;
	reg [31:0] Result1, Result2;
	
	assign zero = ~| Result1;
	always@(*) begin
		if(func == `ADD) begin
			ADD_SUB_Src2 = Src2;
			Carry_internal[0] = 1'b0;
			Result1 = Sum;
		end
		else if (func == `SUB)begin
			ADD_SUB_Src2 = ~Src2;
			Carry_internal[0] = 1'b1;
			Result1 = Sum;
		end
	end
	always@(*) begin
		if(func == `OR_OP) begin
			Result2 = Src1 | Src2;
		end
		else if(func == `SHIFT_OP)begin
			Result2 = shift_stage5;
		end
	end
	assign Result = (func[1]) ? Result2: Result1;
endmodule
