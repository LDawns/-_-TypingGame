module level(clk,level_num,data);

input clk;
input [4:0]level_num;

output wire [143:0]data;

num_ip	new_num_ip_inst (
	.address ( level_num ),
	.clock ( clk ),
	.data ( 144'b0 ),
	.wren ( 1'b0 ),
	.q ( data )
	);

endmodule
