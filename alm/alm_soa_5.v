module Barrel8L(
    input [7:0] data_i,
    input [2:0] shift_i,
    output reg [7:0] data_o
    );	 
 
   always @*
      case (shift_i)
         3'd0: data_o = data_i;
         3'd1: data_o = data_i << 1;
         3'd2: data_o = data_i << 2;
         3'd3: data_o = data_i << 3;
         3'd4: data_o = data_i << 4;
         3'd5: data_o = data_i << 5;
         3'd6: data_o = data_i << 6;
         3'd7: data_o = data_i << 7;
      endcase

endmodule


module Barrel8R (
    input [7:0] data_i,
	input [2:0] shift_i,
	output reg [7:0] data_o
    );

	always @*
      case (shift_i)
         3'd0: data_o = data_i;
         3'd1: data_o = data_i >> 1;
         3'd2: data_o = data_i >> 2;
         3'd3: data_o = data_i >> 3;
         3'd4: data_o = data_i >> 4;
         3'd5: data_o = data_i >> 5;
         3'd6: data_o = data_i >> 6;
         3'd7: data_o = data_i >> 7;
      endcase
endmodule


module Barrel16L(
    input [15:0] data_i,
    input [3:0] shift_i,
    output reg [15:0] data_o
    );	 
 
   always @*
      case (shift_i)
         4'd0: data_o = data_i;
         4'd1: data_o = data_i << 1;
         4'd2: data_o = data_i << 2;
         4'd3: data_o = data_i << 3;
         4'd4: data_o = data_i << 4;
         4'd5: data_o = data_i << 5;
         4'd6: data_o = data_i << 6;
         4'd7: data_o = data_i << 7;
         4'd8: data_o = data_i<<8;
         4'd9: data_o = data_i << 9;
         4'd10: data_o = data_i << 10;
         4'd11: data_o = data_i << 11;
         4'd12: data_o = data_i << 12;
         4'd13: data_o = data_i << 13;
         4'd14: data_o = data_i << 14;
         4'd15: data_o = data_i << 15;
      endcase

endmodule


module carry_lookahead_inc(
    input [2:0] i_add1,
    output [3:0] o_result
);
    
    wire [2:0] carry;
    wire [2:0] sum;
    
    // Generate carry signals using lookahead logic
    assign carry[0] = 1'b1; // Incrementing, so initial carry-in is 1
    assign carry[1] = (i_add1[0] & carry[0]);
    assign carry[2] = (i_add1[1] & carry[1]);
    
    // Compute sum bits
    assign sum[0] = i_add1[0] ^ carry[0];
    assign sum[1] = i_add1[1] ^ carry[1];
    assign sum[2] = i_add1[2] ^ carry[2];

    // Output the incremented result
    assign o_result = {carry[2],sum};
    
endmodule


module AntiLog(
    input  [10:0] data_i,   // [10] = lr flag, [9:7] = exponent, [6:0] = fraction
    output [15:0] data_o    // 16-bit approximate product output
);

    // -------------------------------
    // Left Barrel Shift Branch (for lr = 1)
    // -------------------------------
    wire [15:0] l1_in;
    assign l1_in = {8'b0, 1'b1, data_i[6:0]};  // 8 + 1 + 7 = 16 bits

    wire [2:0] k_enc;
    wire [3:0] k_enc_inc;
    assign k_enc = {1'b0,data_i[9:7]};  // Extract exponent
    // assign k_enc_inc = k_enc + 3'b001;  // Simple increment

    carry_lookahead_inc inc(
        .i_add1(k_enc),
        .o_result(k_enc_inc)
    );

    wire [15:0] l1_out;
    Barrel16L L1shift (
        .data_i(l1_in),
        .shift_i(k_enc_inc),
        .data_o(l1_out)
    );

    // -------------------------------
    // Right Barrel Shift Branch (for lr = 0)
    // -------------------------------
    wire [7:0] r_in;
    assign r_in = {1'b1, data_i[6:0]};  // 1 + 7 = 8 bits

    wire [2:0] enc;
    assign enc = ~data_i[9:7];  // Compute correct right-shift amount

    wire [7:0] r_out;
    Barrel8R Rshift (
        .data_i(r_in),
        .shift_i(enc),
        .data_o(r_out)
    );
    
    // assign data_o = data_i[10] ? l1_out : {8'd0, r_out};  // Full selection
    wire [7:0] data_msb,data_lsb;
    assign data_msb= {8{data_i[10]}}&l1_out[15:8];
    assign data_lsb=data_i[10] ? l1_out[7:0] : r_out; 
    assign data_o = {data_msb,data_lsb};  // Full selection

endmodule

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
    
    assign mux2 = data_i[3] ? 1'b0 : 1'b1;
    assign mux1 = data_i[2] ? 1'b0 : mux2;
    assign mux0 = data_i[1] ? 1'b0 : mux1;
    
    assign data_o[3] = data_i[3];
    assign data_o[2] = (mux2 & data_i[2]);
    assign data_o[1] = (mux1 & data_i[1]);
    assign data_o[0] = (mux0 & data_i[0]);
endmodule


module LOD2(
    input [1:0] data_i,
    output [1:0] data_o
    ); 
    wire mux0;

    assign mux0 = data_i[1] ? 1'b0 : 1'b1;

    assign data_o[1] = data_i[1];
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

    LOD2 lod4_middle (
        .data_i( zdet),  // Expand zdet to 4-bit
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


module ALM_SOA(
    input [8:0] x,
    input [8:0] y,
    output [16:0] p
    );

    wire [7:0] A,B;
    assign A=x[7:0];
    assign B=y[7:0];

    wire [7:0] LODa,LODb;
    wire [2:0] kA,kB;
    wire zeroA,zeroB;

    LOD lodA(A,zeroA,LODa);
    LOD lodB(B,zeroB,LODb);

    PEncoder peA(LODa,kA);
    PEncoder peB(LODb,kB);

    wire [2:0] kA_inv;
	wire [7:0] barrelA;
	
	assign kA_inv = ~kA;
	
	Barrel8L BShiftA (
		.data_i(A),
		.shift_i(kA_inv),
		.data_o(barrelA)
 	 ); 

    wire [2:0] kB_inv;
	wire [7:0] barrelB;

	assign kB_inv = ~kB;
	
	Barrel8L BShiftB (
		.data_i(B),
		.shift_i(kB_inv),
		.data_o(barrelB)
 	 );

    wire [4:0] op1,op2;
    wire [10:0] L;

    assign op1={kA,barrelA[6:5]};
    assign op2={kB,barrelB[6:5]};

    assign c_in = A[4] & B[4];

    assign L[10:5] = op1 + op2 + c_in;
    assign L[4:0] = {5{1'b1}};

    wire [15:0] tmp_out; 

	AntiLog anti_log(
		.data_i(L),
		.data_o(tmp_out)
	);
	
	wire prod_sign; 
	wire [15:0] tmp_sign;
	
	assign prod_sign = x[8] ^ y[8];
	assign tmp_sign = {17{prod_sign}} ^ tmp_out;
	
	// is zero 
	wire not_zero;
	assign not_zero = (~zeroA | x[8] | x[0]) & (~zeroB | y[8] | y[0]);
	
	assign p = not_zero ? tmp_sign : 16'b0;

endmodule