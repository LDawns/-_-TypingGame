module data_select(h_addr,v_addr,data,temp,win,DisLine,boss_show,win_show,lose_show,lose,start,start_show);

input [9:0]h_addr;
input [9:0]v_addr;
input [0:479]data,temp,win,lose,start;
input boss_show,win_show,lose_show,start_show;

output reg[0:479]DisLine;

always @(*)
begin
	if(start_show)
	begin
		if(boss_show&&h_addr>=45&&h_addr<=595)
			DisLine <= data;
		else if(win_show)
			DisLine <= win;
		else if(lose_show)
			DisLine <= lose;
		else DisLine <= temp;
	end
	else DisLine <= start;
end
endmodule
