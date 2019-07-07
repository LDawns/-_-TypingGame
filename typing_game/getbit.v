module getbit(clk,h_ascii,v_addr,bit);
input clk;
input [8:0]h_ascii;
input [9:0]v_addr;
output reg bit;
always @(negedge clk)
begin
	bit<=h_ascii[v_addr&10'b0000000111];
end


endmodule
