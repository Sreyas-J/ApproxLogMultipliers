// ----------------------------------------------------------------------------
// File: full_adder.v
// Module: full_adder
// Description: This module implements a 1-bit full adder circuit.
// A full adder adds three bits (a, b, cin) and produces a sum bit and a carry-out bit.
//
// Parameters:
//   sum  - Output      - The sum bit result (a XOR b XOR cin)
//   cout - Output      - The carry-out bit (goes to next stage in multi-bit adders)
//   a    - Input       - First input bit to add
//   b    - Input       - Second input bit to add
//   cin  - Input       - Carry-in bit from previous stage (or initial carry-in)
//
// Usage: This module is commonly used as a building block for larger adders, like
// multi-bit ripple carry adders or more complex adder architectures.
// ----------------------------------------------------------------------------

`ifndef FULL_ADDER_V       
`define FULL_ADDER_V       

module full_adder(sum, cout, a, b, cin);

    // Output port declarations:
    // sum - The sum bit (result of adding a, b, and cin, without the carry)
    // cout - The carry-out bit (generated when two or more input bits are 1)
    output sum, cout;
    
    // Input port declarations:
    // a, b - The two input bits to add
    // cin - The carry-in bit from a previous addition stage (or initial carry-in)
    input a, b, cin;
    
    // This single line implements the full adder functionality:
    // 1. a + b + cin calculates the sum of the three input bits
    // 2. The result could be 0, 1, 2, or 3 (requiring 2 bits to represent)
    // 3. {cout, sum} is a concatenation operation, creating a 2-bit value
    //    where cout is the more significant bit and sum is the less significant bit
    assign {cout, sum} = a + b + cin;
    
endmodule

`endif  