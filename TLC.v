module and_gate(i1,i2,o);
   input i1,i2;
   output o;
   
   assign o=i1&i2;
endmodule


module or_gate(i1,i2,o);
   input i1,i2;
   output o;
   
   assign o=i1|i2;
endmodule


module not_gate(i,o);
   input i;
   output o;
   
   assign o=~i;
endmodule



module DFF(q,d,clk,rst);

   input d,clk,rst;
   output reg q;
   
 always @ (posedge clk or posedge rst)
begin
if (rst==1)
q<=0;
else
q<=d;
end
endmodule


module mux8to1(in,sel,out);
   
   input [7:0] in;
   input [2:0] sel;
   output out;
   
   assign out=in[sel];
endmodule

module counter(clk,reset,count);
input clk,reset;
parameter N=3;

output[N:0] count;
reg [N:0] count;

always @(posedge clk or posedge reset)
 begin
if(reset==1)
           count=4'b0;
else
           count=count+1;
end
endmodule


module  timer_control(A,tm,ts,tms,ty);
output tm,ts,tms,ty;
input [3:0] A;

assign tm=(A[3])&(~A[2])&(~A[1])&(~A[0]);
assign tms=(~A[3])&(A[2])&(A[1])&(~A[0]);
assign ts=(~A[3])&(A[2])&(~A[1])&(~A[0]);
assign ty=(A[3])&(A[2])&(~A[1])&(A[0]);

endmodule

module tl_controller(p1,p2,rst,s1red,s1green,s1yellow,s2red,s2green,s2yellow,m1red,m1green,m1yellow,m2green,m2red,m2yellow,clk);

input p1,p2,rst,clk;

output s1red,s1green,s1yellow,s2red,s2green,s2yellow,m1red,m1green,m1yellow,m2green,m2red,m2yellow;
wire [7:0]a1,a2,a3,a4,m1r,m2r,s1r,s2r,m1y,m2y,s1y,s2y,m1g,m2g,s1g,s2g;
wire[2:0]sel;
wire [3:0]out,count;
wire tm,ts,tms,ty;

assign a1[0]=1'b0;
assign a1[1]=tm & p1;
assign a1[2]=1'b0;
assign a1[3]=ts;
assign a1[4]=1'b1;
assign a1[5]=1'b1;
assign a1[6]=~ty;
assign a1[7]=1'b1;


assign a2[0]=1'b0;
assign a2[1]=(tm&p1)|(tm&p2);
assign a2[2]=1'b1;
assign a2[3]=~ts;
assign a2[4]=1'b0;
assign a2[5]=tms;
assign a2[6]=~ty;
assign a2[7]=~ty;


assign a3[0]=1'b1;
assign a3[1]=(tm&p1)|~(tm&p2);
assign a3[2]=ty;
assign a3[3]=~ts;
assign a3[4]=ty;
assign a3[5]=~tms;
assign a3[6]=ty;
assign a3[7]=1'b1;


mux8to1 M1(a1,sel,out[0]);
mux8to1 M2(a2,sel,out[1]);
mux8to1 M3(a3,sel,out[2]);

DFF d1(sel[2],out[0],clk,rst);
DFF d2(sel[1],out[1],clk,rst);
DFF d3(sel[0],out[2],clk,rst);

assign a4[0]=1'b1;
assign a4[1]=(tm&p1)|((~(tm&p1)&(tm&p2)));
assign a4[2]=ty;
assign a4[3]=ts;
assign a4[4]=ty;
assign a4[5]=tms;
assign a4[6]=ty;
assign a4[7]=ty;

mux8to1 M4(a4,sel,out[3]);
counter C1(clk,out[3],count);
timer_control T(count,tm,ts,tms,ty);

assign s1r[4:1]=4'b1111;
assign s1r[6:5]=2'b00;
assign s1r[0]=1'b0;
assign s1r[7]=1'b1;

mux8to1 Ms1r(s1r,sel,s1red);

assign s1y[5:0]=5'b00000;
assign s1y[6]=1'b1;
assign s1y[7]=1'b0;

mux8to1 Ms1y(s1y,sel,s1yellow);

assign s1g[4:0]=5'b00000;
assign s1g[5]=1'b1;
assign s1g[7:6]=2'b00;

mux8to1 Ms1g(s1g,sel,s1green);

assign s2r[4:3]=2'b00;
assign s2r[2:1]=2'b11;
assign s2r[0]=1'b0;
assign s2r[7]=1'b1;
assign s2r[5]=1'b1;
assign s2r[6]=1'b0;

mux8to1 Ms2r(s2r,sel,s2red);



assign s2y[3:0]=4'b0000;
assign s2y[7:5]=3'b000;
assign s2y[4]=1'b1;

mux8to1 Ms2y(s2y,sel,s2yellow);


assign s2g[2:0]=3'b000;
assign s2g[5:4]=2'b00;
assign s2g[6]=1'b1;
assign s2g[3]=1'b1;
assign s2g[7]=1'b0;
mux8to1 Ms2g(s2g,sel,s2green);


assign m2r[6:3]=4'b1111;
assign m2r[2:0]=3'b00;
assign m2r[7]=1'b0;
mux8to1 Mm2r(m2r,sel,m2red);

assign m2y[1:0]=2'b00;
assign m2y[6:3]=4'b0000;
assign m2y[2]=1'b1;
assign m2y[7]=1'b1;
mux8to1 Mm2y(m2y,sel,m2yellow);


assign m2g[7:2]=6'b000000;
assign m2g[0]=1'b0;
assign m2g[1]=1'b1;
mux8to1 Mm2g(m2g,sel,m2green);

assign m1r[4:3]=2'b11;
assign m1r[2:0]=3'b00;
assign m1r[7:5]=3'b000;
mux8to1 Mm1r(m1r,sel,m1red);

assign m1y[1:0]=2'b00;
assign m1y[7:3]=5'b00000;
assign m1y[2]=1'b1;
mux8to1 Mm1y(m1y,sel,m2yellow);


assign m1g[7:5]=3'b111;
assign m1g[0]=1'b0;
assign m1g[1]=1'b1;
assign m1g[4:2]=3'b000;
mux8to1 Mm1g(m1g,sel,m1green);

endmodule


module test_tlc;
reg  p1,p2,rst,clk;
wire s1red,s1green,s1yellow,s2red,s2green,s2yellow,m1red,m1green,m1yellow,m2green,m2red,m2yellow;

tl_controller TLC1(p1,p2,rst,s1red,s1green,s1yellow,s2red,s2green,s2yellow,m1red,m1green,m1yellow,m2green,m2red,m2yellow,clk);
initial
clk<=1'b0;
always
#5 clk<=~clk;
initial
begin
$dumpfile("tl_controller.vcd");
$dumpvars(0,test_tlc);
$monitor($time,"p1=%b,p2=%b,rst=%b,s1red=%b,s1green=%b,s1yellow=%b,s2red=%b,s2green=%b,s2yellow=%b,m1red=%b,m1green=%b,m1yellow=%b,m2green=%b,m2red=%b,m2yellow=%b,clk=%b",p1,p2,rst,s1red,s1green,s1yellow,s2red,s2green,s2yellow,m1red,m1green,m1yellow,m2green,m2red,m2yellow,clk);
#0 rst=1;
#5 p1=0;p2=0; rst=0;
#16 p1=1; p2=1;
#30 p1=0; p2=1;
#30 p1=1; p2=0;
#30 p1=0; p2=0;
#10 $finish;
end
endmodule
 
