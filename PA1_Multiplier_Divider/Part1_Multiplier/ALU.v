module ALU(input [31:0] Src_1, input [31:0] Src_2, 
			output wire Carry, output wire [31:0] Result);
	//assign {Carry, Result} = (flag == 1) ? (Src_1 + Src_2) : 33'b0;
	// Internal wires
    wire [8:0] Carry_internal;
    wire [31:0] Sum;

    assign Carry_internal[0] = 1'b0;

    // Generate 8 CLA4 blocks
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : CLA4_BLOCK
            wire [3:0] A = Src_1[i*4 +: 4];
            wire [3:0] B = Src_2[i*4 +: 4];
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

    assign Result = Sum;
    assign Carry = Carry_internal[8];

endmodule


