module Product(input [31:0]Multiplier_in, input pre_finish, input ALU_carry
			,input [31:0] ALU_result, input Reset, input clk, input Run, 
			input Ready, output reg [63:0] Product, output wire add_flag);
	initial begin
		Product = 64'b0;
	end
	assign add_flag = (Product[0] == 1) ? 1: 0;
	
	always@(posedge clk) begin
		if(Reset == 1) begin
			Product <= {32'b0, Multiplier_in};
		end
		if(Run == 1 && pre_finish == 0) begin
			if(Product[0] == 1) begin
				Product[63:31] <= {ALU_carry, ALU_result};
				Product[30:0] <= Product[31:1];
			end
			else begin
				Product[63:0] <= {1'b0, Product[63:1]};
			end
		end
	end
endmodule

