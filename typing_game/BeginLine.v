module BeginLine(DisLine,FallLine,start,level,clk,Ascii,h_addr,ready,led0,clra,w_addr);
input [7:0]Ascii;
input [9:0]h_addr;
input [0:479]DisLine;
input clk;
input clra;
output reg[0:479]FallLine;
output reg ready;
output reg start;
output reg [2:0]level;
output reg led0;
output reg [9:0]w_addr;
reg [2:0]anslevel;
//start = 1 begin game
integer i=0;
reg [7:0]State;
reg [7:0]DownState;
reg over;
wire [12:0]ArrowLine;
wire [12:0]ArrowHang[3:0];

wire [143:0]Font;

wire signed [479:0]tem1;
wire [479:0]tem2;
wire [479:0]Right1;
wire [479:0]Right2;
wire [15:0]FontLine[8:0];

initial
begin
	State<=0;
	DownState<=0;
	over<=0;
	level<=0;
	anslevel<=0;
	start<=0;
	led0<=0;
	// 32 inter
end
assign ArrowLine=270;
assign ArrowHang[0]=192;
assign ArrowHang[1]=224;
assign ArrowHang[2]=256;
assign ArrowHang[3]=288;

//192-304
assign Font=144'h0000010001000100054007C0038001000000;
assign FontLine[0]=Font[143:128];
assign FontLine[1]=Font[127:112];
assign FontLine[2]=Font[111:96];
assign FontLine[3]=Font[95:80];
assign FontLine[4]=Font[79:64];
assign FontLine[5]=Font[63:48];
assign FontLine[6]=Font[47:32];
assign FontLine[7]=Font[31:16];
assign FontLine[8]=Font[15:0];


always @(posedge clk)
begin
		if(over)
		begin
			i<=i;
		end
		else if(i==2500000)
		begin
			if(State)
			begin
				if(State==10)
				begin
					State<=0;
					ready<=0;
					i<=0;
				end
				else if(h_addr==ArrowLine+State-1)
				begin
					ready<=1;
					State<=State+1'b1;
					w_addr<=h_addr;
					case(level)
					0:begin
						FallLine<={DisLine[0:191],FontLine[(State-1'b1)],96'b0,DisLine[304:479]};
					end
					1:begin
						FallLine<={DisLine[0:191],32'b0,FontLine[(State-1'b1)],64'b0,DisLine[304:479]};
					end
					2:begin
						FallLine<={DisLine[0:191],64'b0,FontLine[(State-1'b1)],32'b0,DisLine[304:479]};
					end
					3:begin
						FallLine<={DisLine[0:191],96'b0,FontLine[(State-1'b1)],DisLine[304:479]};
					end
					default:begin
						FallLine<=DisLine;
					end
					endcase
				end
				else
					ready<=0;
			end
			
			else if(Ascii==8'h77&&!clra)//w
			begin
				led0<=!led0;
				anslevel<=level;
				if(level==0)
					level<=3;
				else 
					level<=level-1'b1;
				State<=1;
			end
			
			else if(Ascii==8'h73&&!clra)//s
			begin
				led0<=!led0;
				anslevel<=level;
				if(level==3)
					level<=0;
				else
					level<=level+1'b1;
				State<=1;
			end
			
			else if(Ascii==8'h0d&&!clra)//enter
			begin
				led0<=!led0;
				State<=0;
				over<=1;
				start<=1;
			end
			
			else
				i<=0;
		end
		else 
			i<=i+1'b1;
end
endmodule

