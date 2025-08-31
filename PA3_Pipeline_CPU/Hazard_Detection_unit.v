module Hazard_detection(
    input Mem_write,
    input [4:0] RsAddr,
    input [4:0] RtAddr,
    input [4:0] RdAddr,
    output reg stall_control
);
initial begin
    stall_control = 0;
end
    always @(*) begin
        if(Mem_write == 1) begin
            if(RdAddr == RsAddr || RdAddr == RtAddr) begin
                stall_control = 1;
            end
            else begin
                stall_control = 0;
            end
        end
        else begin
            stall_control = 0;
        end
    end

endmodule