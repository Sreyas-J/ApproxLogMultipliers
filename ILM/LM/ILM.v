module Decoder (
    input [15:0] in,
    output reg [15:0] out
);

    always @(*) begin
    out = 16'b0;
    out[in] = 1'b1;
end
    
endmodule


module PropFA (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    wire not_b, not_a, not_cin;
    assign not_a = ~a;
    assign not_b = ~b;
    assign not_cin = ~cin;

    wire temp1, temp2, temp3, temp4, temp5;
    assign temp1 = not_b && cin;
    assign temp2 = not_a && b && not_cin;
    assign temp3 = a && not_b;
    assign sum = temp1 + temp2 + temp3;

    assign temp4 = a && b;
    assign temp5 = b && cin;
    assign cout = temp4 + temp5; 
    
endmodule


module Propadder(

    input [15:0] A,
    input [15:0] B,
    input cin,
    output [16:0] sum,
    output cout

);

    wire [15:0] inter_cout;
    assign sum[16] = 0;

    PropFA PFA1(A[0],B[0],cin,sum[0],inter_cout[0]);

    genvar i;
    generate

        for(i = 1; i<16; i = i+1)
        begin

            PropFA PFA2(A[i], B[i], inter_cout[i-1], sum[i], inter_cout[i]);

        end

    endgenerate

    assign cout = inter_cout[15];


endmodule

module threebit_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);

    assign sum = a + b;


endmodule


module eightbit_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum

);
    assign sum = a+b;

endmodule

module shifter(

    input [15:0] q,
    input [15:0] k,
    output [15:0] shift

);

    assign shift = q << k;


endmodule

module subtractor(

    input [7:0] a,
    input [15:0] b,
    output [15:0] sub

);

    assign sub = a-b;

endmodule



module NOD (
    input [7:0] A,
    output [15:0] O
);


    assign O[15:8] = 0;
    wire [5:0]t;
    wire [6:0] invert;
    wire [3:0] temp1;
    wire [3:0] temp2;
    wire [3:0] temp3;

    wire inter1;
    assign inter1 = A[6] && A[5];
    assign O[7] = A[7] || inter1;

    
    assign t[0] = ~A[7];
    wire not_a5;
    assign not_a5 = ~A[5];
    wire inter2;
    assign inter2 = A[6] && not_a5;
    wire not_a6;
    assign not_a6 = ~A[6];
    wire inter3;
    assign inter3 = A[5] && not_a6 && A[4];
    wire inter4;
    assign inter4 = inter2 || inter3;
    assign O[6] = t[0] && inter4;

    genvar i;
    generate
        
        for(i=5; i>1; i=i-1)
        begin
            

            assign invert[i+1] = ~A[i+1];
            assign invert[i] = ~A[i];
            assign invert[i-1] = ~A[i-1];
            assign t[6-i] = t[5-i] && invert[i+1];
            assign temp1[5-i] = A[i] && invert[i-1];
            assign temp2[5-i] = A[i-1] && invert[i] && A[i-2];
            assign temp3[5-i] = temp1[5-i] || temp2[5-i];
            assign O[i] = t[6-i] && temp3[5-i];

        end 


    endgenerate

    assign t[5] = t[4] && invert[2];
    assign invert[0] = ~A[0];
    wire inter5;
    assign inter5 = A[1] && invert[0];
    assign O[1] = t[5] && inter5;

    assign O[0] = t[5] && invert[1] && A[0];


    
endmodule


module PEncoder (
    input [15:0] A,
    output [15:0] out
);

    assign out[15:3] = 0;
    wire temp1, temp2, temp3, temp4, temp5;

    assign temp1 = A[1] || A[3];
    assign temp2 = A[2] || A[3];
    assign temp3 = A[4] || A[5];
    assign temp4 = A[6] || A[7];
    assign temp5 = A[5] || A[7];

    assign out[0] = temp1 || temp5;
    assign out[1] = temp2 || temp4;
    assign out[2] = temp3 || temp4;
    
endmodule

module ILM(

    input [8:0] in1,
    input [8:0] in2,
    //  output sign,
    output [16:0] product,
    output carry

);

     wire [7:0] A,B;
     assign A = in1[7:0];
     assign B = in2[7:0];

    //  assign sign = in1[8] ^ in2[8];

    wire [15:0] NOD_out1, NOD_out2;
    
    NOD n1(A,NOD_out1);
    NOD n2(B,NOD_out2);

    wire [15:0] q1, q2;
    subtractor s1(A, NOD_out1, q1);
    subtractor s2(B, NOD_out2, q2);

    wire [15:0] k1, k2;
    PEncoder p1(NOD_out1, k1);
    PEncoder p2(NOD_out2, k2);

    wire [15:0] sum_k;
    threebit_adder ts1(k1, k2, sum_k);

    wire [15:0] two_pq1, two_pq2;
    shifter shift1(q1,k2,two_pq1);
    shifter shift2(q2, k1, two_pq2);

    wire [15:0] intermediate;
    Decoder d(sum_k, intermediate);

    wire [15:0] intermediate2;
    eightbit_adder sa(two_pq1, two_pq2, intermediate2 );
    
    wire [16:0] inter_prod;
    wire cout;
    Propadder padd(intermediate, {intermediate2}, 1'b0, inter_prod, cout);

    assign product = inter_prod;
    assign carry = cout;


endmodule