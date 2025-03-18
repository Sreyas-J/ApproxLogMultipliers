// ----------------------------------------------------------------------------
// Module: cla_4bit
// Description: A 4-bit Carry Lookahead Adder (CLA) that computes the sum of two 4-bit 
// numbers and produces group propagate/generate signals for use in hierarchical CLA designs.
//
// Parameters:
//   sum [3:0] - Output - The 4-bit sum result of adding a and b with initial carry c0
//   ps        - Output - Group propagate signal for the entire 4-bit block
//   gs        - Output - Group generate signal for the entire 4-bit block
//   a [3:0]   - Input  - First 4-bit input operand
//   b [3:0]   - Input  - Second 4-bit input operand
//   c0        - Input  - Initial carry-in bit
//
// Note: This module depends on carry_prop_gen.v and sum.v modules
// ----------------------------------------------------------------------------

//`include "carry_prop_gen.v"   // Include file for propagate/generate calculation (commented out)
//`include "sum.v"              // Include file for sum calculation (commented out)

module cla_4bit(sum, ps, gs, a, b, c0);
    // Output port declarations:
    output [3:0] sum;     // 4-bit sum result
    output gs, ps;        // Group generate and propagate signals for the entire 4-bit block
    //wire c4;            // Commented out final carry-out declaration
    
    // Input port declarations:
    input [3:0] a, b;     // Two 4-bit inputs to add
    input c0;             // Initial carry-in
    
    // Internal signals:
    wire [3:0] p, g;      // Bit-level propagate and generate signals
    wire c1, c2, c3;      // Internal carry signals between bit positions
    
    // Generate bit-level propagate (p) and generate (g) signals for each bit position
    // p[i] = a[i] XOR b[i] (will propagate a carry)
    // g[i] = a[i] AND b[i] (will generate a carry)
    carry_prop_gen cpg1(.p(p), .g(g), .a(a), .b(b));
    
    // Calculate the group generate signal (gs) for the entire 4-bit block
    // A carry will be generated from this block if:
    // - Bit 3 generates a carry, OR
    // - Bit 2 generates a carry AND Bit 3 can propagate it, OR
    // - Bit 1 generates a carry AND Bits 2-3 can propagate it, OR
    // - Bit 0 generates a carry AND Bits 1-3 can propagate it
    assign gs = g[3] | g[2]&p[3] | g[1]&p[2]&p[3] | g[0]&p[1]&p[2]&p[3]; 
    
    // Calculate the group propagate signal (ps) for the entire 4-bit block
    // A carry can propagate through this block only if all bits can propagate a carry
    assign ps = p[3]&p[2]&p[1]&p[0];
    
    // Calculate the internal carry signals between bit positions
    carry_2 ca1(.c1(c1), .c2(c2), .c3(c3), .p(p), .g(g), .c0(c0));
    
    // Calculate the sum using the propagate signals and carry signals
    // s[i] = p[i] XOR c[i] (where c[i] is the carry-in to bit i)
    sum s1(.s(sum), .p(p), .c({c3, c2, c1, c0}));
endmodule

// ----------------------------------------------------------------------------
// Module: carry_2
// Description: Calculates internal carry signals for a 4-bit CLA using the
// carry lookahead logic. This eliminates the need to wait for carries to
// ripple through bit positions.
//
// Parameters:
//   c1       - Output - Carry into bit position 1
//   c2       - Output - Carry into bit position 2
//   c3       - Output - Carry into bit position 3
//   p [3:0]  - Input  - Bit-level propagate signals
//   g [3:0]  - Input  - Bit-level generate signals
//   c0       - Input  - Initial carry-in
// ----------------------------------------------------------------------------

module carry_2(c1, c2, c3, p, g, c0);
    // Output port declarations:
    output c1, c2, c3;   // Carry signals into bit positions 1, 2, and 3
    
    // Input port declarations:
    input [3:0] p, g;    // Bit-level propagate and generate signals
    input c0;            // Initial carry-in
    
    // Calculate c1 (carry into bit position 1)
    // A carry into position 1 occurs if:
    // - Bit 0 generates a carry, OR
    // - The initial carry-in (c0) is 1 AND Bit 0 can propagate it
    assign c1 = g[0] | c0&p[0]; 
    
    // Calculate c2 (carry into bit position 2)
    // A carry into position 2 occurs if:
    // - Bit 1 generates a carry, OR
    // - Bit 0 generates a carry AND Bit 1 can propagate it, OR
    // - The initial carry-in is 1 AND Bits 0-1 can both propagate it
    assign c2 = g[1] | g[0]&p[1] | c0&p[0]&p[1];
    
    // Calculate c3 (carry into bit position 3)
    // A carry into position 3 occurs if:
    // - Bit 2 generates a carry, OR
    // - Bit 1 generates a carry AND Bit 2 can propagate it, OR
    // - Bit 0 generates a carry AND Bits 1-2 can both propagate it, OR
    // - The initial carry-in is 1 AND Bits 0-2 can all propagate it
    assign c3 = g[2] | g[1]&p[2] | g[0]&p[1]&p[2] | c0&p[0]&p[1]&p[2];
    
    // Final carry-out calculation (commented out)
    //assign c4 = g[3] | g[2]&p[3] | g[1]&p[2]&p[3] | g[0]&p[1]&p[2]&p[3] | c0&p[0]&p[1]&p[2]&p[3];
endmodule