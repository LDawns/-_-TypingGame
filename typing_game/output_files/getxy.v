module getxy(clk,v_addr,h_addr,scan_x,scan_y);
input clk;
input [9:0]h_addr;
input [9:0]v_addr;
output reg [7:0]scan_x;
output reg [7:0]scan_y;

always @ (posedge clk)
begin
	scan_x<=v_addr<560 ? v_addr>>3 : 0;
	scan_y<=v_addr<560 ? h_addr>>4 : 0;
end
endmodule
