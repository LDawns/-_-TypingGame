module c_bos(clk,boss,pause,start);
input clk;
input start;
input [4:0]boss;
integer x;
output reg pause;

reg [5:0]c_boss=0;

always @(posedge clk)
begin
	if(boss==3&&start)
	begin
		if(x==2500000)
		begin
			x <= 0;
			if(c_boss == 10)
			begin
				pause <= 1;
				c_boss <= c_boss;
			end
			else c_boss <= c_boss+1'b1;
		end
		else begin
		x <= x+1'b1;
		if(c_boss == 10)
			pause <= 1;
		else pause <= 0;
		end
	end
	else pause <= 1;
end
endmodule
