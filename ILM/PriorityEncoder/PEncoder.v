
module PEncoder (
    input [7:0] A,
    output [2:0] out
);

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