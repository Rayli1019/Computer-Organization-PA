module ALU(input [31:0] Src_1, input [31:0] Src_2, 
			output wire Carry, output wire [31:0] Result);
    wire [31:0] B_invert;
    wire [8:0] Carry_internal;
    wire [31:0] Sum;

    assign B_invert = ~Src_2;         // Step 1: 取反 B
    assign Carry_internal[0] = 1'b1;  // Step 2: 加上 +1，完成 2's complement

    // Look-ahead Adder 結構：Src_1 + ~Src_2 + 1
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : CLA4_BLOCK
            wire [3:0] A = Src_1[i*4 +: 4];
            wire [3:0] B = B_invert[i*4 +: 4];
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
    assign Carry  = ~Carry_internal[8];  // 若結果為正（MSB = 0），Carry = 1
endmodule

