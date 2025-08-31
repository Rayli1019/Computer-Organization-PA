module Control(input Run, input Reset, input clk, 
			output reg Ready, output reg pre_finish);
	reg [6:0] step_count;
	initial begin
		step_count = 0;
		Ready = 0;
	end
	always@(*) begin
		if(Reset == 1) begin
			Ready = 0;
			pre_finish = 0;
		end
		else if(step_count == 32) begin
			pre_finish = 1;
		end
		else if(step_count == 33) begin
			Ready = 1;
		end
	end
	always@(posedge clk) begin
		if(Reset == 1) begin
			step_count = 0;
		end
		else if(Run == 1 && step_count < 33) begin
			step_count = step_count + 1;
		end
	end
endmodule

