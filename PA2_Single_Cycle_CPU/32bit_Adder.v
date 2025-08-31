module Adder_32bit(input [31:0] Src1, input [31:0] Src2, output wire [31:0]Result);
	wire [8:0] Carry_internal;

    assign Carry_internal[0] = 1'b0;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : CLA4_BLOCK
            wire [3:0] A = Src1[i*4 +: 4];
            wire [3:0] B = Src2[i*4 +: 4];
            wire [3:0] G, P, C;

            assign G = A & B;
            assign P = A ^ B;

            assign C[0] = Carry_internal[i];
            assign C[1] = G[0] | (P[0] & C[0]);
            assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
            assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
            assign Carry_internal[i+1] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) |
                                         (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
            assign Result[i*4 +: 4] = P ^ C;
        end
    endgenerate
endmodule
