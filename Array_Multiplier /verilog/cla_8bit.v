// ----------------------------------------------------------------------------
// Module: cla_8bit
// Description: An 8-bit Carry Lookahead Adder (CLA) implemented using two 4-bit CLA modules
// and a carry module. The CLA design reduces delay by calculating carries in parallel
// instead of waiting for them to propagate like in a ripple carry adder.
//
// Parameters:
//   sum [7:0] - Output - The 8-bit sum result of adding a and b with initial carry c0
//   c8        - Output - The final carry-out bit after addition
//   a [7:0]   - Input  - First 8-bit input operand
//   b [7:0]   - Input  - Second 8-bit input operand
//   c0        - Input  - Initial carry-in bit
//
// Included modules:
//   - carry.v: Generates carry signals based on propagate/generate signals
//   - carry_prop_gen.v: Calculates propagate and generate signals
//   - sum.v: Computes the sum bits using XOR operations
//   - cla_4bit.v: A 4-bit carry lookahead adder module
// ----------------------------------------------------------------------------

// Include required modules for the design
`include "carry.v"           // Module for calculating carry signals
`include "carry_prop_gen.v"  // Module for calculating propagate/generate signals
`include "sum.v"             // Module for calculating sum bits
`include "cla_4bit.v"        // The 4-bit CLA module that we'll use twice

module cla_8bit(sum, c8, a, b, c0);
    // Output port declarations:
    output [7:0] sum;      // 8-bit sum result
    output c8;             // Final carry-out bit
    
    // Input port declarations:
    input [7:0] a, b;      // Two 8-bit inputs to add
    input c0;              // Initial carry-in
    
    // Internal wires:
    wire [1:0] gs, ps;     // Group generate and propagate signals from the 4-bit blocks
    wire c4;               // Carry-out from the first 4-bit block to the second
    
    // First 4-bit CLA module handles the lower 4 bits (bits 0-3)
    // .sum(sum[3:0]): Connect the 4-bit sum output to the lower 4 bits of the final sum
    // .ps(ps[0]): Store the propagate signal for the lower 4-bit group
    // .gs(gs[0]): Store the generate signal for the lower 4-bit group
    // .a(a[3:0]), .b(b[3:0]): Connect the lower 4 bits of inputs a and b
    // .c0(c0): Pass the initial carry-in to the first block
    cla_4bit c4b1(.sum(sum[3:0]), .ps(ps[0]), .gs(gs[0]), .a(a[3:0]), .b(b[3:0]), .c0(c0));
    
    // Second 4-bit CLA module handles the upper 4 bits (bits 4-7)
    // .sum(sum[7:4]): Connect the 4-bit sum output to the upper 4 bits of the final sum
    // .ps(ps[1]): Store the propagate signal for the upper 4-bit group
    // .gs(gs[1]): Store the generate signal for the upper 4-bit group
    // .a(a[7:4]), .b(b[7:4]): Connect the upper 4 bits of inputs a and b
    // .c0(c4): Pass the carry-out from the first block as carry-in to the second block
    cla_4bit c4b2(.sum(sum[7:4]), .ps(ps[1]), .gs(gs[1]), .a(a[7:4]), .b(b[7:4]), .c0(c4));
    
    // The carry module calculates the carries between blocks using the group
    // propagate and generate signals
    // .c1(c4): The carry into the second 4-bit block
    // .c2(c8): The final carry-out from the entire 8-bit addition
    // .p(ps): Array of propagate signals from each 4-bit block
    // .g(gs): Array of generate signals from each 4-bit block
    // .c0(c0): The initial carry-in
    carry c1(.c1(c4), .c2(c8), .p(ps), .g(gs), .c0(c0));
endmodule


/*
module tb_cla_16bit();
	reg [15:0] a,b;
	reg c0;
	wire [15:0] d;
	wire cout;
	cla_16bit uut(.sum(d),.c16(cout),.a(a),.b(b),.c0(c0));
	
	initial
	begin
	#00 a=16'd10; b=16'd10; c0 = 1'b0; //10-2
	#20 a=16'd30; b=16'd20; c0 = 1'b0;
	#20 a=16'd150; b=16'd130; c0 = 1'b0; //3-5
	#20 a=16'd20000; b=16'd25555; c0 = 1'b0;
	#20 $stop;
	end
	
	initial
	begin
	$monitor("time=%3d, a=%16d, b=%16d, co=%b, d=%16d, cout=%1b",$time,a,b,c0,d,cout);
	end
		
	initial
	begin
	$dumpfile("cla_16bit.vcd");
	$dumpvars;
	end
	
endmodule
*/