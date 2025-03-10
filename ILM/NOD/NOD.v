

module NOD (
    input [7:0] A,
    output [7:0] O
);

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