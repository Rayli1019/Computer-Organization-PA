module pipline_register_1(
    input [29:0] instruction,
    input clk,
    input stall,
    output reg [29:0] stage1
);
    always@(posedge clk) begin
        if(!stall) begin
            stage1 <= instruction;    
        end
    end
endmodule
/*
control_bus = ALU_OP[7:6], Reg_Dst:5, Reg_w:4, ALU_src:3, Mem_to_reg:2, Mem_w:1, Mem_r:0
*/
module pipline_register_2(
    input [101:0]input_bus,
    input clk,
    output reg [101:0]stage2 // shift, ALU_op, ALU_OP
);
    always@(posedge clk) begin
        stage2 <= input_bus;
    end
endmodule
/*
Reg_Dst:5, Reg_w:4, ALU_src:3, Mem_to_reg:2, Mem_w:1, Mem_r:0
*/
module pipline_register_3(
    input [71:0]input_bus,
    input clk,
    output reg [71:0] stage3
);
    always@(posedge clk) begin
        stage3 <= input_bus;
    end
endmodule

module pipline_register_4(
    input [37:0]input_bus,
    input clk,
    output reg [37:0] stage4
);
    always@(posedge clk) begin
        stage4 <= input_bus;
    end
endmodule
