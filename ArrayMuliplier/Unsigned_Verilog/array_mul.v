`timescale 1ns / 1ps

module array_mul(a,b,s);

input [3:0] a,b;
output [7:0] s;

wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11;
wire t1,t2,t3,t4,t5,t6;
wire p00,p10,p20,p30,p01,p11,p21,p31,p02,p12,p22,p32,p03,p13,p23,p33;

assign p00 = a[0] & b[0];  assign p01 = a[0] & b[1];
assign p10 = a[1] & b[0];  assign p11 = a[1] & b[1];
assign p20 = a[2] & b[0];  assign p21 = a[2] & b[1];
assign p30 = a[3] & b[0];  assign p31 = a[3] & b[1];

assign p02 = a[0] & b[2];  assign p03 = a[0] & b[3];
assign p12 = a[1] & b[2];  assign p13 = a[1] & b[3];
assign p22 = a[2] & b[2];  assign p23 = a[2] & b[3];
assign p32 = a[3] & b[2];  assign p33 = a[3] & b[3];

assign s[0] = p00;

fa m1(p01,p10,1'b0,s[1],c1);
fa m2(p11,p20,1'b0,t1,c2);
fa m3(p21,p30,1'b0,t2,c3);

fa m4(t1,c1,p02,s[2],c4);
fa m5(t2,c2,p12,t3,c5);
fa m6(p31,c3,p22,t4,c6);

fa m7(t3,c4,p03,s[3],c7);
fa m8(t4,c5,p13,t5,c8);
fa m9(p32,c6,p23,t6,c9);

fa m10(t5,c7,1'b0,s[4],c10);
fa m11(t6,c8,c10,s[5],c11);
fa m12(p33,c9,c11,s[6],s[7]);
endmodule
