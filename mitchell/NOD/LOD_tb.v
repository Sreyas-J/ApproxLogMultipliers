`timescale 1ns / 1ps

module LOD_tb;
    
    reg [7:0] A;
    wire [7:0] O;
    wire zero_o;
    
    // Instantiate the LOD module
    LOD uut (
        .A(A),
        .zero_o(zero_o),
        .O(O)
    );
    
    initial begin
        // Dump waves for GTKWave
        $dumpfile("LOD_tb.vcd");
        $dumpvars(0, LOD_tb);
        
        // Monitor signals
        $monitor("Time=%0t A=%b O=%b", $time, A, O);
        
        // Apply test vectors
        A = 8'b00000000; #10; // Test case 1: All zeros
        A = 8'b00000001; #10; // Test case 2: Single 1 at LSB
        A = 8'b00000011; #10; // Test case 3: Single 1 at bit 1
        A = 8'b00000111; #10; // Test case 4: First three bits high
        A = 8'b01101100; #10; // Test case 5: Random middle bits
        A = 8'b10101010; #10; // Test case 6: Alternating bits
        A = 8'b11111111; #10; // Test case 7: All ones
        A = 8'b10000000; #10;
        A = 8'd73; #10 // Test case 8: Single 1 at MSB
        
        // End simulation
        $finish;
    end
    
endmodule
