module clk_s(clk,clk_1s,clk_10ms);

input clk;
output reg clk_1s=0;
output reg clk_10ms=0;
reg [25:0] count_clk = 0,count_clk_100=0;
reg [1:0] c = 0;
always @(posedge clk)
	begin
	if(count_clk>=25000000)
		begin
		count_clk <= 0;
		clk_1s <= ~clk_1s;
		end
	else
		count_clk <= count_clk + 1;
	end
	
always @(posedge clk)
	begin
	if(count_clk_100>=100000)
		begin
		count_clk_100 <= 0;
		clk_10ms <= ~clk_10ms;
		end
	else
		count_clk_100 <= count_clk_100 + 1;
	end
endmodule 	