module DoLineFall(clk,DisLine,FallLine,Font,f_addr,h_addr,w_addr,ready,boss,boss_show);
input clk;
input [0:479]DisLine;
input [9:0]h_addr;
input [143:0]Font;
input [9:0]f_addr;
output reg[9:0]w_addr;
output reg[0:479]FallLine;
output reg ready;
output boss;
output reg boss_show;
/****for get num_module ***********/
reg[2:0]level;
reg[4:0]score_t;
reg[4:0]target[2:0];
reg[4:0]target_t;
reg [4:0]score[2:0];
reg [4:0]chance=9;
/**************************************/
integer i;
integer j;
integer k;
reg boss=0;
reg flag=0;

//wire [3:0]Level;
wire [15:0]FontLine[8:0];
reg FontReady;
/******for data****************/
wire [15:0]fuck[8:0];
wire [15:0]chance_d[8:0];
wire [15:0]target_d[8:0];
wire [15:0]fuck_t[8:0];
/*****************************/
reg[9:0] LineState;
reg[12:0] FontState;
wire [12:0] NineFontState;
/***********for num module*********/
wire [143:0]data;
wire [143:0]data_t;
wire [143:0]data_chance;
wire [143:0]data_target;
/**********************************/
//reg state;
initial 
begin
	LineState<=0;
	FontState<=0;
//	h_data_addr <= 0;
	target[0] <= 0;
	target[1] <= 0;
	target[2] <= 2;
	i<=0;
	j<=0;
end

assign FontLine[0]=Font[143:128];
assign FontLine[1]=Font[127:112];
assign FontLine[2]=Font[111:96];
assign FontLine[3]=Font[95:80];
assign FontLine[4]=Font[79:64];
assign FontLine[5]=Font[63:48];
assign FontLine[6]=Font[47:32];
assign FontLine[7]=Font[31:16];
assign FontLine[8]=Font[15:0];

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


/******************changed****************/
level level_num
(
	.clk(clk) ,	// input  clk_sig
	.level_num(level) ,	// input [2:0] level_num_sig
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
/******************changed****************/


always @(posedge clk)
begin
	if(i==2500000)
	begin
		if(LineState==640)//end
		begin
			LineState<=0;
			ready<=0;
			if(j==32)
			begin
				j<=0;
/******************changed****************/				
				level <= level + 1;	//加等级
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
				
				if(target[0] == 0)	begin
					if(target[1]==0)begin
						if(target[2]==0)begin
							target[0] <= 0;
							target[1] <= 0;
							target[2] <= 0;
							flag <= 1;
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
				
				if(chance == 0)
					chance <= 0;
				else chance <= chance - 1;
/******************changed****************/

				FontReady<=1;		//ready to add font
			end
			else
			begin
				i<=0;
				j<=j+1'b1;
			end
		end
		
	   else if(FontReady==1)
		begin
			if(FontState==9)										//end
			begin
				FontState<=0;
				ready<=0;
				i<=0;
				FontReady<=0;
			end
		
			else if((f_addr+FontState)==h_addr)													
			//remain
			begin
				w_addr<=h_addr;
				FontState<=FontState+1'b1;
				if(flag == 0)
					FallLine<={FontLine[FontState],DisLine[16:479]};
				else FallLine <= DisLine;
				ready<=1;
			end
			
			else 
				ready<=0;
		end
		
		else if(LineState==h_addr)
		begin
/******************changed****************/
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
			
			if(LineState>=54 && LineState <= 577)	
				begin
				FallLine<=DisLine>>1;
				end
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
/******************changed****************/			
			LineState<=LineState+1'b1;
			w_addr<=h_addr;
			ready<=1;
		end
		
		else
			ready<=0;
	end
	
	else
	begin
		i<=i+1;
		ready<=0;
	end
end

/******************changed****************/
always @(posedge clk)
begin
	if(k==1250000)
	begin
		k <= 0;
		if(level == 4)
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
	else k <= k+1;
end
/******************changed****************/
endmodule
