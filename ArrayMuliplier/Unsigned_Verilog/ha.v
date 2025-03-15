`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:00 05/06/2018 
// Design Name: 
// Module Name:    ha 
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

module ha(input a, input b, output sum, output carry);
    assign sum = a ^ b;   // XOR for sum
    assign carry = a & b; // AND for carry
endmodule
