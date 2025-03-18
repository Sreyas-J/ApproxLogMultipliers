// ----------------------------------------------------------------------------
// Module: carry
// Description: This module calculates the carry signals for a 2-level CLA (Carry Lookahead Adder)
// design. It takes group propagate and generate signals from lower-level blocks and
// calculates the carry signals between blocks.
//
// Parameters:
//   c1       - Output - Carry into the second block
//   c2       - Output - Final carry-out (carry after the second block)
//   p [1:0]  - Input  - Group propagate signals from two blocks
//   g [1:0]  - Input  - Group generate signals from two blocks
//   c0       - Input  - Initial carry-in
//
// Usage: This module is used in hierarchical CLA designs to calculate carries between
// multi-bit blocks (e.g., between 4-bit CLA blocks in an 8-bit CLA).
// ----------------------------------------------------------------------------

module carry(c1, c2, p, g, c0);
    // Output port declarations:
    output c1, c2;       // Carry signals: c1 is carry into second block, c2 is final carry-out
    
    // Input port declarations:
    input [1:0] p, g;    // Group propagate and generate signals from two blocks
    input c0;            // Initial carry-in to the first block
    
    // Calculate c1 (carry into the second block)
    // This is the carry-out from the first block, which occurs if:
    // - The first block generates a carry (g[0]), OR
    // - The initial carry-in (c0) propagates through the first block (c0 & p[0])
    assign c1 = g[0] | (c0 & p[0]);  
    
    // Calculate c2 (final carry-out after the second block)
    // This occurs if:
    // - The second block generates a carry (g[1]), OR
    // - The first block generates a carry that propagates through the second block (g[0] & p[1]), OR
    // - The initial carry-in propagates through both blocks (c0 & p[0] & p[1])
    assign c2 = g[1] | (g[0] & p[1]) | (c0 & p[0] & p[1]);

endmodule