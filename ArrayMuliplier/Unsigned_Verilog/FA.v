`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:18:02 05/06/2018 
// Design Name: 
// Module Name:    FA 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module fa(input a, input b, input cin, output sum, output cout);
    wire s1, c1, c2;
    
    ha ha1 (.a(a), .b(b), .sum(s1), .carry(c1));
    ha ha2 (.a(s1), .b(cin), .sum(sum), .carry(c2));
    
    assign cout = c1 | c2; // Carry out
endmodule
