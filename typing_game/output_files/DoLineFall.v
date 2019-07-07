module DoLineFall(clk,DisLine,FallLine,CharLine,WCharLine,LineNum,CharReady,Font,Ascii,f_addr,h_addr,w_addr,ready,KeyAscii,clra,boss,boss_show,Vmax,win,lose,start,InitLevel);
input clk;
input clra;
input [0:479]DisLine;
input [9:0]h_addr;
input [143:0]Font;
input [9:0]f_addr;
input [7:0]Ascii;
input start;
input [2:0]InitLevel;




wire pause;
wire pause_b;
reg pause_l;
output reg[9:0]w_addr;
output reg[0:479]FallLine;
output reg ready;
output reg boss_show;
output reg boss;
output reg win;
output reg lose;
integer i;
integer j;
integer k;
integer o;
/**level speed contrl**/
integer Speed[4:0];
wire [7:0]CharSpeed[4:0];
/************************/
reg flag=0;

/************************/
wire [15:0]FontLine[8:0];
reg FontReady;
reg[9:0] LineState;
reg[12:0] FontState;
wire [12:0] NineFontState;
//reg state;


//for delete it!
reg [7:0]Num9;
reg [12:0]index;
output reg [12:0]Vmax;
reg [12:0]Pmax;
output reg [7:0] LineNum;
output reg [35:0] WCharLine;
input [35:0] CharLine;
output reg CharReady;
wire [7:0]Ascii1;
wire [7:0]Ascii2;

wire [12:0]y1;
wire [12:0]y2;
wire [12:0]y11;
wire [12:0]y12;
//keyboard
reg KeyReady;
reg KeyIn;
reg [7:0]KeyState;
input [12:0]KeyAscii;
wire [7:0]kasc;
wire signed [479:0]tem1;
wire [479:0]tem2;
wire [479:0]Right1;
wire [479:0]Right2;

//level_switch
reg[7:0] NumTarget;
reg[7:0] NumMiss;
reg[7:0] NumScore;

//level_count
wire [9:0]InitTarget[4:0];
wire [4:0]TenTarget[4:0];


/******for data****************/
wire [15:0]fuck[8:0];
wire [15:0]chance_d[8:0];
wire [15:0]target_d[8:0];
wire [15:0]fuck_t[8:0];
/*****************************/

/***********for num module*********/
wire [143:0]data;
wire [143:0]data_t;
wire [143:0]data_chance;
wire [143:0]data_target;
/**********************************/

/****for get num_module ***********/
reg[2:0]level;
wire [5:0]level_t;
reg[4:0]score_t;
reg[4:0]target[2:0];
reg[4:0]target_t;
reg [4:0]score[2:0];
reg [4:0]chance=9;
/**************************************/


initial 
begin
	LineState<=0;
	FontState<=0;
	i<=0;
	j<=0;
	k<=0;
	LineNum<=0;
	CharReady<=0;
	Num9<=0;
	KeyState=0;	
	KeyIn<=0;
	target[0]<=0;
	target[1]<=3;
	target[2]<=0;
	Speed[0]<=1250000;
	Speed[1]<=625000;
	Speed[2]<=500000;
	Speed[3]<=2500000;
	Speed[4]<=500000;
	NumTarget<=30;
	win <= 0;
	lose <= 0;
end
assign	InitTarget[0]=10;
assign	InitTarget[1]=30;
assign	InitTarget[2]=50;
assign	InitTarget[3]=0;
assign 	InitTarget[4]=30;

assign CharSpeed[0]=32;
assign CharSpeed[1]=25;
assign CharSpeed[2]=18;
assign CharSpeed[3]=15;
assign CharSpeed[4]=8;

assign tem1={1'b1,{479{1'b0}}};
assign tem2={16'h0000,{464{1'b1}}};

assign Right1=tem1>>>(Vmax-1'b1);
assign Right2=tem2>>Vmax;

assign FontLine[0]=Font[143:128];
assign FontLine[1]=Font[127:112];
assign FontLine[2]=Font[111:96];
assign FontLine[3]=Font[95:80];
assign FontLine[4]=Font[79:64];
assign FontLine[5]=Font[63:48];
assign FontLine[6]=Font[47:32];
assign FontLine[7]=Font[31:16];
assign FontLine[8]=Font[15:0];



assign Ascii1=CharLine[35:28];
assign y1=CharLine[27:18];
assign Ascii2=CharLine[17:10];
assign y2=CharLine[9:0];
assign y11=y1+1'b1;
assign y12=y2+1'b1;


assign TenTarget[0]=1;
assign TenTarget[1]=3;
assign TenTarget[2]=5;
assign TenTarget[3]=0;
assign TenTarget[4]=3;
assign kasc=KeyAscii[7:0];


/***************changed************************/
assign fuck[0] = data[143:128];
assign fuck[1] = data[127:112];
assign fuck[2] = data[111:96];
assign fuck[3] = data[95:80];
assign fuck[4] = data[79:64];
assign fuck[5] = data[63:48];
assign fuck[6] = data[47:32];
assign fuck[7] = data[31:16];
assign fuck[8] = data[15:0];

assign fuck_t[0] = data_t[143:128];
assign fuck_t[1] = data_t[127:112];
assign fuck_t[2] = data_t[111:96];
assign fuck_t[3] = data_t[95:80];
assign fuck_t[4] = data_t[79:64];
assign fuck_t[5] = data_t[63:48];
assign fuck_t[6] = data_t[47:32];
assign fuck_t[7] = data_t[31:16];
assign fuck_t[8] = data_t[15:0];

assign chance_d[0] = data_chance[143:128];
assign chance_d[1] = data_chance[127:112];
assign chance_d[2] = data_chance[111:96];
assign chance_d[3] = data_chance[95:80];
assign chance_d[4] = data_chance[79:64];
assign chance_d[5] = data_chance[63:48];
assign chance_d[6] = data_chance[47:32];
assign chance_d[7] = data_chance[31:16];
assign chance_d[8] = data_chance[15:0];

assign target_d[0] = data_target[143:128];
assign target_d[1] = data_target[127:112];
assign target_d[2] = data_target[111:96];
assign target_d[3] = data_target[95:80];
assign target_d[4] = data_target[79:64];
assign target_d[5] = data_target[63:48];
assign target_d[6] = data_target[47:32];
assign target_d[7] = data_target[31:16];
assign target_d[8] = data_target[15:0];
/***************changed***************************/



//


level level_num
(
	.clk(clk) ,	// input  clk_sig
	.level_num(level_t) ,	// input [2:0] level_num_sig
	.data(data) 	// output [143:0] data_sig
);

level score_num
(
	.clk(clk) ,	// input  clk_sig
	.level_num(score_t) ,	// input [2:0] level_num_sig
	.data(data_t) 	// output [143:0] data_sig
);

level target_num
(
	.clk(clk) ,	// input  clk_sig
	.level_num(target_t) ,	// input [2:0] level_num_sig
	.data(data_target) 	// output [143:0] data_sig
);

level chance_num
(
	.clk(clk) ,	// input  clk_sig
	.level_num(chance) ,	// input [2:0] level_num_sig
	.data(data_chance) 	// output [143:0] data_sig
);


//



always @(posedge clk or negedge pause)
begin
	if(!pause)
	begin
		i<=i;
	end
	else if(!start)
	begin
		i<=i;
		level<=InitLevel;
		target[1]<=TenTarget[InitLevel];
		NumTarget<=InitTarget[InitLevel];
	end
	else if(i==Speed[level])
	begin
		if(LineState==640)//end
		begin
			Num9<=0;
			LineState<=0;
			ready<=0;
			//FontReady<=1;//delete it later
			if(j==CharSpeed[level])
			begin
				j<=0;
				FontReady<=1;		//ready to add font
				CharReady<=0;
				LineNum<=index;
			end
			else if(k==1)
			begin
				LineNum<=Pmax;
				KeyReady<=1;
				CharReady<=0;
				FontReady<=0;
				k<=0;
			end
			else
			begin
				CharReady<=0;
				i<=0;
				k<=k+1'b1;
				j<=j+1'b1;
				LineNum<=0;
			end
		end
		
	   else if(FontReady==1)
		begin
			if(flag)
			begin
				CharReady<=0;
				FontState<=0;
				LineNum<=0;
				ready<=0;
				i<=0;
				FontReady<=0;
			end
			else if(FontState==10)// end
			begin
				CharReady<=0;
				FontState<=0;
				LineNum<=0;
				ready<=0;
				i<=0;
				FontReady<=0;
				
				
				//
				if(target[0] == 0)	begin
					if(target[1]==0)begin
						if(target[2]==0)begin
							target[0] <= 0;
							target[1] <= 0;
							target[2] <= 0;
						end
						else begin
						target[2] <= target[2]-1;
						target[0] <= 9;
						target[1] <= 9;
						end
					end
					else begin
					target[1] <= target[1]-1;
					target[0] <= 9;
					end
				end
				else target[0] <= target[0] - 1;
				//
				if(NumTarget==1)
				begin
					flag<=1;
				end
				
				NumTarget<=NumTarget-1'b1;
			end
		
			
			else if(FontState==9)										//before end
			begin
			//add font into CharMem
				if(Ascii1==0)
				begin
					WCharLine<={Ascii,10'b0,Ascii2,y2[9:0]};
					CharReady<=1;
				end
				else
				begin
					WCharLine<={Ascii1,y1[9:0],Ascii,10'b0};
					CharReady<=1;
				end
				FontState<=FontState+1'b1;
			end
		
			else if((f_addr+FontState)==h_addr)													
			//remain
			begin
				//this line have some pos to add
				if(Ascii1==0||Ascii2==0)
				begin
					w_addr<=h_addr;
					FontState<=FontState+1'b1;
					FallLine<={FontLine[FontState],DisLine[16:479]};
					ready<=1;
				end
				//no pos , break;
				else
				begin
					i<=0;
					j<=0;
					FontState<=0;
					FontReady<=0;
					CharReady<=0;
					LineNum<=0;
					ready<=0;
				end
			end
			
			else 
				ready<=0;
				
		end
		
		
		
		else if(KeyReady==1)
		begin
			if(KeyState==10)
			begin
				KeyState<=0;
				ready<=0;
				Vmax<=0;
				Pmax<=0;
				KeyIn<=0;
				KeyReady<=0;
				CharReady<=0;
				LineNum<=0;
				i<=0;
				k<=0;
				
				//
				if(score[0]+1 == 10)	begin
					score[0] <= 0;
					if(score[1]+1==10)begin
						score[1] <= 0;
						if(score[2]+1==10)begin
							score[2] <= 0;
						end
						else score[2] <= score[2]+1;
					end
					else score[1] <= score[1]+1;
				end
				else score[0] <= score[0] + 1;		
				//
				
				NumScore<=NumScore+1'b1;
			end
			else if(KeyState==9)
			begin
				CharReady<=1;
				KeyState<=KeyState+1'b1;
				if(kasc==Ascii1)
					WCharLine<={8'b0,10'b0,Ascii2,y2[9:0]};
				else
					WCharLine<={Ascii1,y1[9:0],8'b0,10'b0};
			end
		// add some break may be better;
			else if(!KeyIn && !clra && (Vmax>20) &&(kasc==Ascii1||kasc==Ascii2))
			begin
				KeyIn<=1;
			end
		
			else if(KeyIn)// kasc !=0 && clra != 1;
			begin
				if( ((Pmax<<3)+Pmax+KeyState) == h_addr )
				begin
					ready<=1;
					FallLine<=(Right1|Right2)&DisLine;
					KeyState<=KeyState+1'b1;
					w_addr<=h_addr;
				end
				else
					ready<=0;
			end
			
			else 
			begin
				KeyState<=0;
				KeyIn<=0;
				ready<=0;
				i<=0;
				k<=0;
				KeyReady<=0;
				LineNum<=0;
				CharReady<=0;
			end
		end
		
		else if(LineState==h_addr)
		begin
			if(LineState >=8&&LineState<=16)
				score_t <= score[2];
			else if(LineState >=17&&LineState<=25)
				score_t <= score[1];
			else if(LineState >=26&&LineState<=34)
				score_t <= score[0];
			
			if(LineState >=594&&LineState<=602)
				target_t <= target[2];
			else if(LineState >=603&&LineState<=611)
				target_t <= target[1];
			else if(LineState >=612&&LineState<=620)
				target_t <= target[0];
			
			if(LineState>=54 && LineState <= 576)	
				FallLine<=DisLine>>1;
			else if(LineState >=9 && LineState <= 17)
				FallLine <= {DisLine[0:447],fuck_t[LineState-9],DisLine[464:479]};
			else if(LineState >=18 && LineState <= 26)
				FallLine <= {DisLine[0:15],fuck[LineState-18],DisLine[32:447],fuck_t[LineState-18],DisLine[464:479]};
			else if(LineState >=27 && LineState <= 35)
				FallLine <= {DisLine[0:447],fuck_t[LineState-27],DisLine[464:479]};
			else if(LineState >=595&&LineState <= 603)
				FallLine <= {DisLine[0:15],target_d[LineState-595],DisLine[32:479]};
			else if(LineState >=604 && LineState <= 612)
				FallLine <= {DisLine[0:15],target_d[LineState-604],DisLine[32:447],chance_d[LineState-604],DisLine[464:479]};
			else if(LineState >=613 && LineState <= 621)
				FallLine <= {DisLine[0:15],target_d[LineState-613],DisLine[32:479]};
			else FallLine <= DisLine;
			//
			LineState<=LineState+1'b1;
			w_addr<=h_addr;
			ready<=1;
			
			
			// add the y1,y2;
			if(Num9==8)
			begin
				Num9<=0;
				if(LineNum==80)// have bugs yet, but don not care anyway
					LineNum<=0;
				else
					LineNum<=LineNum+1'b1;
				CharReady<=0;
			end
			
			else if(Num9==0)
			begin
				Num9<=Num9+1'b1;
				CharReady<=1;
				
				if(Ascii1&&Ascii2)
				begin
					if(y1>y2)
					begin
						if( (y1+1'b1) >464)
						begin
							NumMiss<=NumMiss+1'b1;
							if(chance == 1)
							begin
								chance <= 1'b0;
								lose <= 1'b1;
							end
							else begin
							chance<=chance-1'b1;
							lose <= 1'b0;
							end
							WCharLine<={8'b0,10'b0,Ascii2,y12[9:0]};
							Vmax<=0;
							Pmax<=0;
						end
						else if( (y1+1'b1) >Vmax)
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=(y1+1'b1);
							Pmax<=LineNum;
						end
						else
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=Vmax;
							Pmax<=Pmax;
						end
					end
					
					else
					begin
						if( (y2+1'b1)>464 )
						begin
							NumMiss<=NumMiss+1'b1;
							if(chance == 1)
							begin
								chance <= 1'b0;
								lose <= 1'b1;
							end
							else begin
							chance<=chance-1'b1;
							lose <= 1'b0;
							end
							WCharLine<={Ascii1,y11[9:0],8'b0,10'b0};
							Vmax<=0;
							Pmax<=0;
						end
						else if( (y2+1'b1)>Vmax)
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=(y2+1'b1);
							Pmax<=LineNum;
						end
						else
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=Vmax;
							Pmax<=Pmax;
						end
					end
				end
				
				else if(Ascii1)
				begin
					if( (y1+1'b1) >464 )
					begin
						NumMiss<=NumMiss+1'b1;
						if(chance == 1)
						begin
							chance <= 1'b0;
							lose <= 1'b1;
						end
						else begin
						chance<=chance-1'b1;
						lose <= 1'b0;
						end
						WCharLine<=0;
						Vmax<=0;
						Pmax<=0;
					end
					else if( (y1+1'b1) >Vmax )
					begin
						WCharLine<={Ascii1,y11[9:0],8'b0,10'b0};
						Vmax<=(y1+1'b1);
						Pmax<=LineNum;
					end
					else
					begin
						WCharLine<={Ascii1,y11[9:0],8'b0,10'b0};
						Pmax<=Pmax;
						Vmax<=Vmax;
					end
				end
				else if(Ascii2)
				begin
					if( (y2+1'b1) >464 )
					begin
						NumMiss<=NumMiss+1'b1;
						if(chance == 1)
						begin
							chance <= 1'b0;
							lose <= 1'b1;
						end
						else begin
						chance<=chance-1'b1;
						lose <= 1'b0;
						end
						WCharLine<=0;
						Vmax<=0;
						Pmax<=0;
					end
					else if( (y2+1'b1) >Vmax)
					begin
						WCharLine<={8'b0,10'b0,Ascii2,y12[9:0]};
						Vmax<=(y2+1'b1);
						Pmax<=LineNum;
					end
					else 
					begin
						WCharLine<={8'b0,10'b0,Ascii2,y12[9:0]};
						Pmax<=Pmax;
						Vmax<=Vmax;
					end
				end
				else 
				begin
					WCharLine<=0;
					Vmax<=Vmax;
					Pmax<=Pmax;
				end
				
			end
			
			else
			begin
				Num9<=Num9+1'b1;
				CharReady<=0;
			end
			
			// compute the f_addr/9 
			if( ( (index<<3) +index) < f_addr)
				index<=index+1'b1;
			else if( (index<<3) +index > f_addr)
				index<=index-1'b1;
			else;
			
			//if(chance==0) when failed
			
			
			if(NumMiss+NumScore==InitTarget[level]&&level!=5)
			begin
				level<=level+1'b1;
				NumMiss<=0;
				NumScore<=0;
				NumTarget<=InitTarget[level+1'b1];
				target[1]<=TenTarget[level+1'b1];
				flag<=0;
				LineNum<=0;
				Num9<=0;
				i<=0;
				j<=0;
				k<=0;
				ready<=0;
				CharReady<=0;
				FontReady<=0;
				Pmax<=0;
				Vmax<=0;
				chance<=9;
				win <= win;
				//ready<=0;
			end
			else if(level==5)
			begin
				win <= 1'b1;
				lose <= 0;
			end
		end
		
		else
			ready<=0;
	end
	/***for some cols speeding up **/
	/*** wish that the col[8] will be up to twice of the speed***/
	else if( i==(Speed[level]>>1) )
	begin
		if(LineState==90)
		begin
			LineState<=0;
			i<=i+1'b1;
			ready<=0;
			LineNum<=0;
		end
		else if(LineState==h_addr)
		begin
			LineState<=LineState+1'b1;
			LineNum<=9;
			if(LineState==81)
			begin
				CharReady<=1;
				FallLine<=DisLine>>1;
				w_addr<=h_addr;
				ready<=1;
				if(Ascii1&&Ascii2)
				begin
					if(y1>y2)
					begin
						if( (y1+1'b1) >464)
						begin
							NumMiss<=NumMiss+1'b1;
							if(chance == 1)
							begin
								chance <= 1'b0;
								lose <= 1'b1;
							end
							else begin
							chance<=chance-1'b1;
							lose <= 1'b0;
							end
							WCharLine<={8'b0,10'b0,Ascii2,y12[9:0]};
							Vmax<=0;
							Pmax<=0;
						end
						else if( (y1+1'b1) >Vmax)
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=(y1+1'b1);
							Pmax<=LineNum;
						end
						else
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=Vmax;
							Pmax<=Pmax;
						end
					end
					
					else
					begin
						if( (y2+1'b1)>464 )
						begin
							NumMiss<=NumMiss+1'b1;
							if(chance == 1)
							begin
								chance <= 1'b0;
								lose <= 1'b1;
							end
							else begin
							chance<=chance-1'b1;
							lose <= 1'b0;
							end
							WCharLine<={Ascii1,y11[9:0],8'b0,10'b0};
							Vmax<=0;
							Pmax<=0;
						end
						else if( (y2+1'b1)>Vmax)
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=(y2+1'b1);
							Pmax<=LineNum;
						end
						else
						begin
							WCharLine<={Ascii1,y11[9:0],Ascii2,y12[9:0]};
							Vmax<=Vmax;
							Pmax<=Pmax;
						end
					end
				end
				
				else if(Ascii1)
				begin
					if( (y1+1'b1) >464 )
					begin
						NumMiss<=NumMiss+1'b1;
						if(chance == 1)
						begin
							chance <= 1'b0;
							lose <= 1'b1;
						end
						else begin
						chance<=chance-1'b1;
						lose <= 1'b0;
						end
						WCharLine<=0;
						Vmax<=0;
						Pmax<=0;
					end
					else if( (y1+1'b1) >Vmax )
					begin
						WCharLine<={Ascii1,y11[9:0],8'b0,10'b0};
						Vmax<=(y1+1'b1);
						Pmax<=LineNum;
					end
					else
					begin
						WCharLine<={Ascii1,y11[9:0],8'b0,10'b0};
						Pmax<=Pmax;
						Vmax<=Vmax;
					end
				end
				else if(Ascii2)
				begin
					if( (y2+1'b1) >464 )
					begin
						NumMiss<=NumMiss+1'b1;
						if(chance == 1)
						begin
							chance <= 1'b0;
							lose <= 1'b1;
						end
						else begin
						chance<=chance-1'b1;
						lose <= 1'b0;
						end
						WCharLine<=0;
						Vmax<=0;
						Pmax<=0;
					end
					else if( (y2+1'b1) >Vmax)
					begin
						WCharLine<={8'b0,10'b0,Ascii2,y12[9:0]};
						Vmax<=(y2+1'b1);
						Pmax<=LineNum;
					end
					else 
					begin
						WCharLine<={8'b0,10'b0,Ascii2,y12[9:0]};
						Pmax<=Pmax;
						Vmax<=Vmax;
					end
				end
				else 
				begin
					WCharLine<=0;
					Vmax<=Vmax;
					Pmax<=Pmax;
				end
				
				
				
			
			
			end
			else if(LineState>81)
			begin
				FallLine<=DisLine>>1;
				w_addr<=h_addr;
				ready<=1;
				CharReady<=0;
			end
			else
			begin
				CharReady<=0;
				ready<=0;
			end
		end
		else
		begin
			CharReady<=0;
			ready<=0;
		end
	end
	
	/**   new bug may be added    **/
	else
	begin
		i<=i+1;
		ready<=0;
	end
end

c_bos c_bos_inst
(
	.clk(clk) ,	// input  clk_sig
	.boss(level) ,	// input  boss_sig
	.pause(pause_b), 	// output  pause_sig
	.start(start)
);

assign level_t = (level==3||level==4)?	4'b1010:level;
assign pause = win?1'b1:(level==3)?pause_b:(~lose);

always @(posedge clk)
begin
	if(o==1250000)
	begin
		o <= 0;
		if(level == 3)
			begin
			boss <= ~boss;
			boss_show <= 1'b1;
			end
		else 
		begin
			boss <= 0;
			boss_show <= 1'b0;
		end
	end
	else o <= o+1;
end
	

	
endmodule
