module vga(ps2_data,ps2_clk,clk,clk_rst,vga_r,vga_g,vga_b,vga_clk,vga_sync_n,vga_blank_n,hsync,vsync,clr,sh,sl,mh,ml,hh,hl,pause,led0);
input clk,clk_rst;
input pause;
input ps2_data,ps2_clk;
output [7:0]vga_r;
output [7:0]vga_g;
output [7:0]vga_b;
output [6:0]sh;
output [6:0]sl;
output [6:0]mh;
output [6:0]ml;
output [6:0]hh;
output [6:0]hl;
output led0;
output vga_clk;
output reg vga_sync_n;
output vga_blank_n;
output hsync,vsync;
input clr;

wire win;
wire lose;
wire SpeedClk;
//wire [143:0]data;
//wire [143:0]temp;
wire clra;
wire [7:0]asc;
wire [9:0]h_addr;
wire [9:0]v_addr;
//wire clk_ran;
wire [7:0] Ascii;
wire hsync,vsync;
//reg [8:0] myfont	[4095:0];
wire [11:0]ascii; 
wire [12:0]scan_x;
wire [12:0]scan_y;
reg [23:0]bits;
reg state;


//keyboard something
wire [35:0] CharLine;
wire [35:0] WCharLine;
wire [7:0] LineNum;
wire CharReady;
wire [7:0] KeyAscii;
wire [7:0]Pmax;
wire [2:0]InitLevel;

//integer i;
wire [0:479] DisLine;
wire [0:479] data;
wire [0:479] temp;
wire [0:479] win_data;
wire [0:479] lose_data;
wire [0:479] start_data;
wire [0:31] DisLine_Other;
wire [0:479] FallLine;
wire ready;
wire [9:0] w_addr;
wire [143:0] Font;
wire [9:0] f_addr;
wire clk_1s;
wire clk_10ms;
wire boss;
wire boss_show;
wire start;
wire [9:0]BeginWaddr;
//wire [2:0]level_num;


//

wire BeginReady;
wire [0:479]BeginInLine;
//
initial
begin
//	$readmemh("vga_font.txt", myfont, 0, 4095);
	vga_sync_n=0;
	state=0;
//	i=0;
end

//assign Font=144'h00000000081018103FF03FF0001000100000;
//
//assign f_addr=30;

DisMem	DisMem_inst (
	.clock ( clk ),
	.data ( FallLine ),
	.rdaddress ( h_addr ),
	.wraddress ( w_addr ),
	.wren ( ready ),
	.q ( temp )
	);

CharMem	CharMem_inst (
	.clock ( clk ),
	.data ( WCharLine ),
	.rdaddress ( LineNum ),
	.wraddress ( LineNum ),
	.wren ( CharReady ),
	.q ( CharLine )
	);
	
boss_show	boss_show_inst (
	.address ( h_addr ),
	.clock ( clk ),
	.data ( 479'b0 ),
	.wren ( 1'b0 ),
	.q ( data )
	);

win_show	win_show_inst (
	.address ( h_addr ),
	.clock ( clk ),
	.data ( 479'b0 ),
	.wren ( 1'b0 ),
	.q ( win_data )
	);

lose_show	lose_show_inst (
	.address ( h_addr ),
	.clock ( clk ),
	.data ( 479'b0 ),
	.wren ( 1'b0 ),
	.q ( lose_data )
	);

start_show	start_show_inst (
	.data ( BeginInLine ),
	.rdaddress ( h_addr ),
	.rdclock ( clk ),
	.wraddress ( BeginWaddr ),
	.wrclock ( clk ),
	.wren ( BeginReady ),
	.q ( start_data )
	);
	//test	test_inst (
//	.address ( h_addr ),
//	.clock ( clk ),
//	.q ( DisLine )
//	);


BeginLine BeginLine_inst
(
	.DisLine(start_data) ,	// input [0:479] DisLine_sig
	.FallLine( BeginInLine ) ,	// output [0:479] FallLine_sig
	.start ( start ) ,	// output  start_sig
	.level( InitLevel ) ,	// output [2:0] level_sig
	.clk( vga_clk ) ,	// input  clk_sig
	.Ascii( KeyAscii ) ,	// input [7:0] Ascii_sig
	.h_addr(h_addr) ,	// input [9:0] h_addr_sig
	.ready(BeginReady) , 	// output  ready_sig
	.led0(led0),
	.clra(clra) ,
	.w_addr(BeginWaddr)
);






//DoLineFall fall(vga_clk,DisLine,FallLine,Font,f_addr,h_addr,w_addr,ready,level_num);	

DoLineFall DoLineFall_inst
(
	.clk(vga_clk) ,	// input  clk_sig
	.DisLine(DisLine) ,	// input [0:479] DisLine_sig
	.FallLine(FallLine) ,	// output [0:479] FallLine_sig
	.CharLine(CharLine) ,	// input [35:0] CharLine_sig
	.WCharLine(WCharLine) ,	// output [35:0] WCharLine_sig
	.LineNum(LineNum) ,	// output [7:0] LineNum_sig
	.CharReady(CharReady) ,	// output  CharReady_sig
	.Font(Font) ,	// input [143:0] Font_sig
	.Ascii(Ascii) ,	// input [7:0] Ascii_sig
	.f_addr(f_addr) ,	// input [9:0] f_addr_sig
	.h_addr(h_addr) ,	// input [9:0] h_addr_sig
	.w_addr(w_addr) ,	// output [9:0] w_addr_sig
	.ready(ready) ,	// output  ready_sig
	.KeyAscii(KeyAscii) ,	// input [12:0] KeyAscii_sig
	.clra(clra) ,	// input  clra_sig
	.boss(boss) ,	// output  boss_sig
	.boss_show(boss_show) ,	// output  boss_show_sig
	.Vmax(Pmax) ,
	.win(win) ,	// output  win_sig
	.lose(lose) ,	// output  lose_sig
	.start(start), 	// input  start_sig
	.InitLevel(InitLevel)
);


random_le random_le_inst
(
	.clk(clk_10ms) ,	// input  clk_sig
	.h_addr(f_addr) ,	// output [9:0] h_addr_sig
	.font(Font) ,	// output [143:0] font_sig
	.asc(Ascii) ,
	.clr(clr)
);

clk_s clk_s_inst
(
	.clk(clk) ,	// input  clk_sig
	.clk_1s(clk_1s) ,	// output  clk_1s_sig
	.clk_10ms(clk_10ms) 	// output  clk_10ms_sig
);

other	other_inst (
	.address ( h_addr ),
	.clock ( clk ),
	.data ( 8'b0 ),
	.wren ( 1'b0 ),
	.q ( DisLine_Other )
	);

//level level_inst
//(
//	.clk(clk) ,	// input  clk_sig
//	.level_num(level_num) ,	// input [2:0] level_num_sig
//	.data(data) 	// output [143:0] data_sig
//);

always @(posedge clk)
begin
	case(state)
	0:begin
		state<=1;
	end
	1:begin
		if(v_addr>=32&&v_addr<448)
		begin
			if(h_addr<=44)
				bits<={8'h00,{8{DisLine[v_addr]}},8'h00};
			else if(h_addr>=585)
				bits<={8'h00,{8{DisLine[v_addr]}},8'h00};
			else if(boss&&start&&h_addr>=254&&h_addr<390)
				bits<={{8{DisLine[v_addr]}},8'h00,8'h00};
			else if(lose&&h_addr>=189&&h_addr<=450)
				bits<={1'b0,{7{DisLine[v_addr]}},1'b0,{7{DisLine[v_addr]}},1'b0,{7{DisLine[v_addr]}}};
			else if(win&&h_addr>=189&&h_addr<=450)
				bits<={{2{DisLine[v_addr]}},6'b000000,{8{DisLine[v_addr]}},2'b00,{2{DisLine[v_addr]}},{3{DisLine[v_addr]}},1'b0};
			else
				bits <= {24{DisLine[v_addr]}};
		end
		else if(v_addr<16)
		begin
			if(h_addr<=44)
				bits<={{DisLine_Other[v_addr],7'b0000000},{8{DisLine_Other[v_addr]}},{8{DisLine_Other[v_addr]}}};
			else if(h_addr>=585)
				bits<={8'h00,{8{DisLine_Other[v_addr]}},8'h00};
			else 
			bits <= {24{DisLine_Other[v_addr]}};
		end
		else if(v_addr>=16&&v_addr<32)
			begin
			if(h_addr<=44)
				bits<={{DisLine[v_addr],7'b0000000},{8{DisLine[v_addr]}},{8{DisLine[v_addr]}}};
			else if(h_addr>=585)
				bits<={8'h00,{8{DisLine[v_addr]}},8'h00};
			else if(boss&&h_addr>=254&&h_addr<390)
				bits<={{8{DisLine[v_addr]}},8'h00,8'h00};
			else
				bits <= {24{DisLine[v_addr]}};
			end
		else if(v_addr>=448&&v_addr<464)
			begin
			if(h_addr<=44)
				bits<={8'h00,{8{DisLine[v_addr]}},8'h00};
			else if(h_addr>=585)
				bits<={{DisLine[v_addr],7'b0000000},{1'b0,DisLine[v_addr],6'b000000},{DisLine[v_addr],7'b0000000}};
			else bits <= {24{DisLine[v_addr]}};
			end
		else
		begin
			if(h_addr<=44)
				bits<={8'h00,{8{DisLine_Other[v_addr-448]}},8'h00};
			else if(h_addr>=585)
				bits<={{DisLine_Other[v_addr-448],7'b0000000},{1'b0,DisLine_Other[v_addr-448],6'b000000},{DisLine_Other[v_addr-448],7'b0000000}};
			else bits <= {24{DisLine_Other[v_addr-448]}};
		end
		state<=0;
	end
	endcase
end

displayhex(KeyAscii,1'b0,sl,sh);

keyboard key(ps2_data,ps2_clk,1'b1,clk,KeyAscii,clra);

clkgen #(25000000) my_vgaclk(clk,!clk_rst,1'b1,vga_clk);

vga_ctrl ctrl(vga_clk,!clk_rst,bits,h_addr,v_addr,hsync,vsync,vga_blank_n,vga_r,vga_g,vga_b);


data_select data_select_inst
(
	.h_addr(h_addr) ,	// input [9:0] h_addr_sig
	.v_addr(v_addr) ,	// input [9:0] v_addr_sig
	.data(data) ,	// input [0:479] data_sig
	.temp(temp) ,	// input [0:479] temp_sig
	.win(win_data) ,	// input [0:479] win_sig
	.DisLine(DisLine) ,	// output [0:479] DisLine_sig
	.boss_show(boss_show) ,	// input  boss_show_sig
	.win_show(win) ,	// input  win_show_sig
	.lose_show(lose) ,
	.lose(lose_data) ,
	.start(start_data) ,
	.start_show(start)
);

//assign DisLine = (boss_show&&h_addr>=45&&h_addr<=595)?data:temp;
endmodule
