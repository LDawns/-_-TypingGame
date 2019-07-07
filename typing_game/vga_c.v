module vga(ps2_data,ps2_clk,clk,clk_rst,vga_r,vga_g,vga_b,vga_clk,vga_sync_n,vga_blank_n,hsync,vsync,sh,sl,mh,ml,hh,hl,pause);
input clk,clk_rst;
input ps2_data,ps2_clk;
input pause;
output [7:0]vga_r;
output [7:0]vga_g;
output [7:0]vga_b;
output [6:0]sh;
output [6:0]sl;
output [6:0]mh;
output [6:0]ml;
output [6:0]hh;
output [6:0]hl;
output vga_clk;
//output reg clk_02s;
output reg vga_sync_n;
output vga_blank_n;
output hsync,vsync;

wire SpeedClk;
wire clra;
wire [7:0]asc;
wire [9:0]h_addr;
wire [9:0]v_addr;
//wire clk_ran;

wire hsync,vsync;
//reg [8:0] myfont	[4095:0];
wire [7:0] Ascii;

wire [11:0]ascii; 
wire [12:0]scan_x;
wire [12:0]scan_y;
reg bits;
reg state;
//integer i;

//keyboard something
wire [35:0] CharLine;
wire [35:0] WCharLine;
wire [7:0] LineNum;
wire CharReady;
wire [7:0] KeyAscii;

wire [0:479] DisLine;
wire [0:31] DisLine_Other;
wire [0:479] FallLine;
wire ready;
wire [9:0] w_addr;
wire [143:0] Font;
wire [9:0] f_addr;
wire clk_1s;
wire clk_10ms;

//debug
wire [7:0] Pmax;
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
	.q ( DisLine )
	);

//CharMem to record each one's (ascii1,y1,ascii2,y2) 
	
CharMem	CharMem_inst (
	.clock ( clk ),
	.data ( WCharLine ),
	.rdaddress ( LineNum ),
	.wraddress ( LineNum ),
	.wren ( CharReady ),
	.q ( CharLine )
	);
	
DoLineFall fall(vga_clk,DisLine,FallLine,CharLine,WCharLine,LineNum,CharReady,Font,Ascii,f_addr,h_addr,w_addr,ready,KeyAscii,clra,pause);	


random_le random_le_inst
(
	.clk(clk_1s) ,	// input  clk_sig
	.h_addr(f_addr) ,	// output [9:0] h_addr_sig
	.font(Font) ,	// output [143:0] font_sig
	.asc(Ascii)
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

	
always @(posedge clk)
begin
	case(state)
	0:begin
		state<=1;
	end
	1:begin
		if(v_addr>=16&&v_addr<464)
			bits<=DisLine[v_addr];
		else if(v_addr<16)
			bits <= DisLine_Other[v_addr];
		else bits <= DisLine_Other[v_addr-448];
		state<=0;
	end
	endcase
end

//displayhex (DebugY,1'b0,sl,sh);
//displayhex (Debuga,1'b0,mh,ml);
//displayhex (Debugb,1'b0,hh,hl);

keyboard key(ps2_data,ps2_clk,1'b1,clk,KeyAscii,clra);

clkgen #(25000000) my_vgaclk(clk,!clk_rst,1'b1,vga_clk);

vga_ctrl ctrl(vga_clk,!clk_rst,bits,h_addr,v_addr,hsync,vsync,vga_blank_n,vga_r,vga_g,vga_b);

endmodule
