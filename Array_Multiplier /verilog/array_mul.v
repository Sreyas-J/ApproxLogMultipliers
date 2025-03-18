`timescale 1ns/10ps
`include "full_adder.v"
`include "cla_8bit.v"

/**
 * Testbench for the 8-bit array multiplier.
 * Provides test cases for verification.
 */
module tb_array_mul();
    reg [7:0] a, b; // 8-bit multiplicand and multiplier
    wire [15:0] prod; // 16-bit product
    
    // Instantiate the array multiplier
    array_mul uut(.prod(prod), .a(a), .b(b));
    
    initial begin
        // Apply test cases with different values
        #20 a = 8'd30; b = 8'd100;
        #20 a = 8'd255; b = 8'd255;
        #20 a = 8'd131; b = 8'd72;
        #20 a = 8'd0; b = 8'd74;
        #20 a = 8'd127; b = 8'd127;
        #20 a = 8'd1; b = 8'd127;
        #20 $stop; // Stop simulation
    end
    
    // Monitor signal changes
    initial begin
        $monitor("time=%3d, a=%3d, b=%3d, prod=%5d", $time, a, b, prod);
    end
    
    // Generate waveform file
    initial begin
        $dumpfile("array_mul.vcd");
        $dumpvars;
    end
endmodule

/**
 * 8-bit unsigned array multiplier
 * Uses partial product generation and row-wise addition.
 */
module array_mul(prod, a, b);
    output [15:0] prod; // 16-bit product output
    input [7:0] a, b; // 8-bit inputs
    
    // Partial product rows
    wire [7:0] pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8;
    
    // Sum and carry wires for intermediate addition
    wire [6:0] ra_sum1, ra_sum2, ra_sum3, ra_sum4, ra_sum5, ra_sum6, ra_sum7;
    wire [6:0] ra_cout1, ra_cout2, ra_cout3, ra_cout4, ra_cout5, ra_cout6, ra_cout7;
    
    // Generate partial products
    pp_bits pb1(.pp(pp1), .a(a), .x(b[0]));
    pp_bits pb2(.pp(pp2), .a(a), .x(b[1]));
    pp_bits pb3(.pp(pp3), .a(a), .x(b[2]));
    pp_bits pb4(.pp(pp4), .a(a), .x(b[3]));
    pp_bits pb5(.pp(pp5), .a(a), .x(b[4]));
    pp_bits pb6(.pp(pp6), .a(a), .x(b[5]));
    pp_bits pb7(.pp(pp7), .a(a), .x(b[6]));
    pp_bits pb8(.pp(pp8), .a(a), .x(b[7]));

    assign prod[0] = pp1[0]; // Least significant bit
    
    // Perform row-wise addition
    row_array ra1(.sum(ra_sum1), .cout(ra_cout1), .a(pp1[7:1]), .b(pp2[6:0]), .cin(7'd0));
    assign prod[1] = ra_sum1[0];
    
    row_array ra2(.sum(ra_sum2), .cout(ra_cout2), .a({pp2[7], ra_sum1[6:1]}), .b(pp3[6:0]), .cin(ra_cout1));
    assign prod[2] = ra_sum2[0];
    
    row_array ra3(.sum(ra_sum3), .cout(ra_cout3), .a({pp3[7], ra_sum2[6:1]}), .b(pp4[6:0]), .cin(ra_cout2));
    assign prod[3] = ra_sum3[0];
    
    row_array ra4(.sum(ra_sum4), .cout(ra_cout4), .a({pp4[7], ra_sum3[6:1]}), .b(pp5[6:0]), .cin(ra_cout3));
    assign prod[4] = ra_sum4[0];
    
    row_array ra5(.sum(ra_sum5), .cout(ra_cout5), .a({pp5[7], ra_sum4[6:1]}), .b(pp6[6:0]), .cin(ra_cout4));
    assign prod[5] = ra_sum5[0];
    
    row_array ra6(.sum(ra_sum6), .cout(ra_cout6), .a({pp6[7], ra_sum5[6:1]}), .b(pp7[6:0]), .cin(ra_cout5));
    assign prod[6] = ra_sum6[0];
    
    row_array ra7(.sum(ra_sum7), .cout(ra_cout7), .a({pp7[7], ra_sum6[6:1]}), .b(pp8[6:0]), .cin(ra_cout6));
    assign prod[7] = ra_sum7[0];
    
    // Final addition using carry look-ahead adder
    cla_8bit c8b1(.sum(prod[15:8]), .c8(), .a({1'd0, pp8[7], ra_sum7[6:1]}), .b({1'd0, ra_cout7}), .c0(1'd0));
endmodule

/**
 * Partial Product Generator
 * @param pp - Partial product output
 * @param a - 8-bit multiplicand
 * @param x - Single-bit multiplier bit
 */
module pp_bits(pp, a, x);
    output [7:0] pp;
    input [7:0] a;
    input x;
    
    wire [7:0] xd;
    assign xd = {8{x}}; // Replicate x across all bits
    assign pp = a & xd; // AND operation to generate partial product
endmodule

/**
 * Row-wise Full Adder Array
 * Performs bitwise addition with carry propagation.
 * @param sum - Sum output
 * @param cout - Carry output
 * @param a - First operand (7-bit)
 * @param b - Second operand (7-bit)
 * @param cin - Carry input (7-bit)
 */
module row_array(sum, cout, a, b, cin);
    output [6:0] sum, cout;
    input [6:0] a, b, cin;
    
    // Perform bitwise full addition
    full_adder fa1(.sum(sum[0]), .cout(cout[0]), .a(a[0]), .b(b[0]), .cin(cin[0]));
    full_adder fa2(.sum(sum[1]), .cout(cout[1]), .a(a[1]), .b(b[1]), .cin(cin[1]));
    full_adder fa3(.sum(sum[2]), .cout(cout[2]), .a(a[2]), .b(b[2]), .cin(cin[2]));
    full_adder fa4(.sum(sum[3]), .cout(cout[3]), .a(a[3]), .b(b[3]), .cin(cin[3]));
    full_adder fa5(.sum(sum[4]), .cout(cout[4]), .a(a[4]), .b(b[4]), .cin(cin[4]));
    full_adder fa6(.sum(sum[5]), .cout(cout[5]), .a(a[5]), .b(b[5]), .cin(cin[5]));
    full_adder fa7(.sum(sum[6]), .cout(cout[6]), .a(a[6]), .b(b[6]), .cin(cin[6]));
endmodule