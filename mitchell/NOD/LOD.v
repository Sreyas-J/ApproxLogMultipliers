module Muxes2in1Array4(
    input [3:0] data_i,
    input select_i,
    output [3:0] data_o
    );

    assign data_o = select_i ? data_i : 4'b0000;

endmodule


module LOD4(
    input [3:0] data_i,
    output [3:0] data_o
    ); 
    wire mux0;
    wire mux1;
    wire mux2;
    
    assign mux2 = (data_i[3] == 1) ? 1'b0 : 1'b1;
    assign mux1 = (data_i[2] == 1) ? 1'b0 : mux2;
    assign mux0 = (data_i[1] == 1) ? 1'b0 : mux1;
    
    assign data_o[3] = data_i[3];
    assign data_o[2] = (mux2 & data_i[2]);
    assign data_o[1] = (mux1 & data_i[1]);
    assign data_o[0] = (mux0 & data_i[0]);
endmodule


module LOD(
    input [7:0] A,
    output zero_o,
    output [7:0] O
    );

    wire [7:0] z;
    wire [1:0] select;
    wire [1:0] zdet;

    LOD4 lod4_1 (
        .data_i(A[7:4]), 
        .data_o(z[7:4])
    );

    LOD4 lod4_0 (
        .data_i(A[3:0]), 
        .data_o(z[3:0])
    );

    LOD4 lod4_middle (
        .data_i({2'b00, zdet}),  // Expand zdet to 4-bit
        .data_o(select) // Expand select to match 4-bit output
    );

    assign zdet[1] = A[7] | A[6] | A[5] | A[4];
    assign zdet[0] = A[3] | A[2] | A[1] | A[0];
    assign zero_o = ~(zdet[1] | zdet[0]);

    Muxes2in1Array4 Inst_MUX214_1 (
        .data_i(z[7:4]), 
        .select_i(select[1]), 
        .data_o(O[7:4])
    );

    Muxes2in1Array4 Inst_MUX214_0 (
        .data_i(z[3:0]), 
        .select_i(select[0]), 
        .data_o(O[3:0])
    );

endmodule
