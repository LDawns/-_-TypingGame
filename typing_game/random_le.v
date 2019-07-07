module random_le(clk,h_addr,font,asc,clr);

input clr;
input clk;
output reg [9:0]h_addr=45;
output wire [143:0]font;
output reg [7:0]asc;

reg [5:0]temp;
reg [10:0]c = 0;
random	random_inst (
	.address ( temp ),
	.clock ( clk ),
	.data ( 144'b0 ),
	.wren ( 1'b0 ),
	.q ( font )
	);


always @(posedge clk)
begin
	if(clr)
		begin
		temp <= c%26;
		c <= c + 47;
		if(h_addr + 9*(c%46) <= 568)
			h_addr <= h_addr + 9*(c%46);
		else h_addr <= 9*(h_addr%19) + 54;
		case(temp)
			0: asc <= 8'h61;
			1: asc <= 8'h62;
			2: asc <= 8'h63;
			3: asc <= 8'h64;
			4: asc <= 8'h65;
			5: asc <= 8'h66;
			6: asc <= 8'h67;
			7: asc <= 8'h68;
			8: asc <= 8'h69;
			9: asc <= 8'h6a;
			10: asc <= 8'h6b;
			11: asc <= 8'h6c;
			12: asc <= 8'h6d;
			13: asc <= 8'h6e;
			14: asc <= 8'h6f;
			15: asc <= 8'h70;
			16: asc <= 8'h71;
			17: asc <= 8'h72;
			18: asc <= 8'h73;
			19: asc <= 8'h74;
			20: asc <= 8'h75;
			21: asc <= 8'h76;
			22: asc <= 8'h77;
			23: asc <= 8'h78;
			24: asc <= 8'h79;
			25: asc <= 8'h7a;
		endcase
		end
	else begin
		asc <= 8'h00;
		temp <= 26;
	end
end    
       
endmodule
        