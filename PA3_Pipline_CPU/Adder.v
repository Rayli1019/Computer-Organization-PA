module Adder(input [31:0]Src1, output wire [31:0] Result);
    assign Result = {24'b0 ,Src1[7:0] + 4};
endmodule