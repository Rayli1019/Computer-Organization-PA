`define R_type 2'b00
`define ADD 2'b01
`define SUB 2'b10
`define OR 2'b11
`define SLL 2'b00


`define R_type_ADD 3'b001
`define R_type_SUB 3'b011
`define R_type_SLL 3'b000
`define R_type_OR  3'b101
 
module ALU_control(
    input [2:0] funct_ctrl,
    input [1:0] ALU_OP,
    output reg [1:0] ALU_function
);

    always@(*) begin
        if(ALU_OP == `R_type) begin
            case(funct_ctrl)
                `R_type_ADD: begin
                    ALU_function = `ADD;
                end
                `R_type_SUB: begin
                    ALU_function = `SUB;
                end
                `R_type_SLL: begin
                    ALU_function = `SLL;
                end
                `R_type_OR: begin
                    ALU_function = `OR;
                end
            endcase
        end
        else begin
            ALU_function = ALU_OP;
        end
    end

endmodule