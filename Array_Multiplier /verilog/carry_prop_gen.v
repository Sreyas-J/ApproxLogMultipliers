// ----------------------------------------------------------------------------
// Module: carry_prop_gen
// Description: This module calculates the bit-level propagate and generate signals
// for a Carry Lookahead Adder (CLA). These signals are fundamental to the CLA's
// ability to calculate carries in parallel rather than sequentially.
//
// Parameters:
//   p [3:0] - Output - Propagate signals for each bit position
//   g [3:0] - Output - Generate signals for each bit position
//   a [3:0] - Input  - First 4-bit input operand
//   b [3:0] - Input  - Second 4-bit input operand
//
// Usage: This module is typically used at the beginning of a CLA computation
// to prepare the propagate and generate signals needed for carry calculations.
// ----------------------------------------------------------------------------

module carry_prop_gen(p, g, a, b);
    // Output port declarations:
    output [3:0] p, g;    // 4-bit propagate and generate signals
    
    // Input port declarations:
    input [3:0] a, b;     // Two 4-bit inputs to be added
    
    // Calculate propagate signals using XOR operation
    // p[i] = a[i] XOR b[i]
    // A propagate signal is 1 when exactly one of the inputs is 1
    // This means if there's an incoming carry, it will propagate through this bit
    assign p = a ^ b;
    
    // Calculate generate signals using AND operation
    // g[i] = a[i] AND b[i]
    // A generate signal is 1 when both inputs are 1
    // This means this bit position will generate a carry regardless of incoming carry
    assign g = a & b;
endmodule