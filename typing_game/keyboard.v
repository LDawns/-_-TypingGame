module keyboard(ps2_data,ps2_clk,clrn,clk,asc,clra);
//,data,count,asc,clra,clrk,realdata,readytest,overflow
//module keyboard(ps2_data,ps2_clk,clrn,clk,hh,hl,mh,ml,sh,sl,data);
input ps2_data,ps2_clk,clrn,clk;
//output [6:0]hh;
//output [6:0]hl;
//output [6:0]mh;
//output [6:0]ml;
//output [6:0]sh;
//output [6:0]sl;

//output  overflow;
//output  [7:0]data;
//output  [7:0]count;
output  [7:0]asc;
//output  [7:0]realdata;
output clra;
//output readytest;

wire [7:0]count;
wire [7:0]data;
wire [7:0]realdata;
wire [7:0]asc;
wire clra,clrk;
wire ready;
wire overflow;
wire nextdata_n;
wire readytest;

//data in
ps2_keyboard b(clk,clrn,ps2_clk,ps2_data,data,ready,nextdata_n,overflow);
//data out
data_solve dataana(clk,data,ready,nextdata_n,asc,count,clra,clrk,realdata);

//display times(count,hh,hl);
//displayhex ASCII(asc,clra,mh,ml);
//displayhex RDATA(realdata,clrk,sh,sl);
//assign readytest = ready;
endmodule
