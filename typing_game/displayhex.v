module displayhex(res,clr,out1,out2);
input clr;
input [7:0]res;
output reg[6:0]out1;
output reg[6:0]out2;
always @ (*) 
begin
	if(clr)
	begin
			out1=7'b1111111;
			out2=7'b1111111;
	end
	else 
	begin
		case (res/16)
			0:out1=7'b1000000;
			1:out1=7'b1111001;
			2:out1=7'b0100100;
			3:out1=7'b0110000;
			4:out1=7'b0011001;
			5:out1=7'b0010010;
			6:out1=7'b0000010;
			7:out1=7'b1111000;
			8:out1=7'b0000000;
			9:out1=7'b0010000;
			10:out1=7'b0001000;
			11:out1=7'b0000011;
			12:out1=7'b1000110;
			13:out1=7'b0100001;
			14:out1=7'b0000110;
			15:out1=7'b0001110;
			default:out1=7'b1111111;
		endcase
		case (res%16)
			0:out2=7'b1000000;
			1:out2=7'b1111001;
			2:out2=7'b0100100;
			3:out2=7'b0110000;
			4:out2=7'b0011001;
			5:out2=7'b0010010;
			6:out2=7'b0000010;
			7:out2=7'b1111000;
			8:out2=7'b0000000;
			9:out2=7'b0010000;
			10:out2=7'b0001000;
			11:out2=7'b0000011;
			12:out2=7'b1000110;
			13:out2=7'b0100001;
			14:out2=7'b0000110;
			15:out2=7'b0001110;
			default:out2=7'b1111111;
		endcase
	end
end
endmodule
