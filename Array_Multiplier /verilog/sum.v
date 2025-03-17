// ----------------------------------------------------------------------------
// Module: sum
// Description: This module performs a bitwise XOR operation between two 4-bit inputs
// and produces a 4-bit output. The XOR operation returns 1 when the inputs are different,
// and 0 when they are the same.
//
// Parameters:
//   s - Output [3:0] - The 4-bit result of the XOR operation between p and c
//   p - Input [3:0]  - The first 4-bit input operand
//   c - Input [3:0]  - The second 4-bit input operand
//
// Usage: This module can be used as part of a larger design, such as in an adder circuit
// where it represents the sum bits (without considering carry).
// ----------------------------------------------------------------------------

module sum(s, p, c);
    // Output port declaration:
    // s is a 4-bit wide output (4 wires, with indices 3, 2, 1, 0)
    // The output contains the result of our operation
    output [3:0] s;
    
    // Input port declarations:
    // p and c are both 4-bit wide inputs (4 wires each, with indices 3, 2, 1, 0)
    // These are the values we will operate on
    input [3:0] p, c;
    
    // The actual operation:
    // assign means we're connecting the output to the expression on the right
    // ^ is the XOR (exclusive OR) operator in Verilog
    // This performs a bitwise XOR between p and c, meaning each bit of p is XORed with
    // the corresponding bit of c. For example:
    // s[0] = p[0] ^ c[0]
    // s[1] = p[1] ^ c[1]
    // and so on...
    assign s = p ^ c;
    
    // The module definition ends here
endmodule