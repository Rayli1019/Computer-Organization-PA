`define ADD 2'b01
`define SUB 2'b10
`define SLL 2'b00
`define OR 2'b11

module ALU(
input [31:0] Src1, 
input [31:0] Src2, 
input [1:0] func, 
input [4:0] shift,
output reg [31:0] Result);

    wire [8:0] Carry_internal;
	wire [31:0] Sum;
	wire [31:0] ADD_SUB_Src2;
    // Generate 8 CLA4 blocks
	assign Carry_internal[0] = (func == `ADD) ? 0 : (func == `SUB) ? 1: 1'b0;
	assign ADD_SUB_Src2 = (func == `ADD) ? Src2:
						  (func == `SUB) ? ~Src2: 32'b0;
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
	
	always@(*) begin
		case(func)
			`ADD: begin
				Result = Sum;
			end
			`SUB: begin
				Result = Sum;
			end
			`SLL: begin
				Result = Src1 << shift;
			end
			`OR: begin
				Result = Src1 | Src2;
			end
		endcase
	end
endmodule