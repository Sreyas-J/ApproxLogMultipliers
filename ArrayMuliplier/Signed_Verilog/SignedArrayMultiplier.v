`timescale 1ns / 1ps

module signed_arrayMul(a,b,s
    );
input [3:0] a,b;
output [7:0] s;

wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11;
wire s1,s2,s3,s4,s5,s6;
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

fa m1(p10,1'b0,p01,s[1],c1);
fa m2(p20,1'b0,p11,s1,c2);
SB1 m3(p30,1'b0,p21,s2,c3);

fa m12(s1,c1,p02,s[2],c4);
SB1 m4(s2,c2,p12,s3,c5);
SB1 m5(p31,c3,p22,s4,c6);

SB2 m6(s3,c4,p03,s[3],c7);
SB2 m7(s4,c5,p13,s5,c8);
SB2 m8(p32,c6,p23,s6,c9);

SB1 m9(s5,c7,1'b0,s[4],c10);
SB1 m10(s6,c8,c10,s[5],c11);
SB1 m11(p33,c9,c11,s[6],s[7]);
endmodule

module SB2(x,z,y,s,c
    );
input x,y,z;
output s,c;
wire [1:0] s1;
//assign s1 = ( y -x - z);
//assign s = s1 % 2;
//assign s = (~x & ~y & z) + (~x & y & ~z) + (x & ~y & ~z) + (x & y & z);
assign s = x ^ y ^ z;
//assign c = (s1 + s)>>1;
assign c = (x & y) + (y & ~z) + (~z & x);
endmodule

module SB1(z,y,x,s,c
    );
input x,y,z;
output s,c;
wire [1:0] s1;
//assign s1 = ( y -x - z);
//assign s = s1 % 2;
//assign s = (~x & ~y & z) + (~x & y & ~z) + (x & ~y & ~z) + (x & y & z);
assign s = x ^ y ^ z;
//assign c = (s1 + s)>>1;
assign c = (x & y) + (y & ~z) + (~z & x);
endmodule

