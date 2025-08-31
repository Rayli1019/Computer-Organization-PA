module Forwarding (
    input [4:0] RsAddr,
    input [4:0] RtAddr,
    input [4:0] RdAddr_stage3,
    input [4:0] RdAddr_stage4,
    input Reg_w_stage3,
    input Reg_w_stage4,
    output reg [1:0] Forward_Src1,
    output reg [1:0] Forward_Src2
);
initial begin
    Forward_Src1 = 2'b00;
    Forward_Src2 = 2'b00;
end
    always @(*) begin
        if(Reg_w_stage3 == 1 && RdAddr_stage3 == RsAddr) begin
            Forward_Src1 = 10;
        end
        else if(Reg_w_stage4 == 1 && RdAddr_stage4 == RsAddr) begin
            Forward_Src1 = 01;
        end
        else begin
            Forward_Src1 = 00;
        end
        if(Reg_w_stage3 == 1 && RdAddr_stage3 == RtAddr) begin
            Forward_Src2 = 10;
        end
        else if(Reg_w_stage4 == 1 && RdAddr_stage4 == RtAddr) begin
            Forward_Src2 = 01;
        end
        else begin
            Forward_Src2 = 00;
        end
    end

endmodule
/*
        if(Reg_w_stage3) begin
            if(RdAddr_stage3 == RsAddr) begin
                Forward_Src1 = 2'b10;
            end
            else begin
                Forward_Src1 = 2'b00;
            end
            if(RdAddr_stage3 == RtAddr) begin
                Forward_Src2 = 2'b10;
            end
            else begin
                Forward_Src2 = 2'b00;
            end
        end
        else if(Reg_w_stage4) begin
            if(RdAddr_stage4 == RsAddr) begin// && RsAddr != RdAddr_stage3
                Forward_Src1 = 2'b01;
            end
            else begin
                Forward_Src1 = 2'b00;
            end
            if(RdAddr_stage4 == RtAddr) begin// && RsAddr != RdAddr_stage3
                Forward_Src2 = 2'b01;
            end
            else begin
                Forward_Src2 = 2'b00;
            end
        end
        else begin
            Forward_Src1 = 2'b00;
            Forward_Src2 = 2'b00;
        end
*/