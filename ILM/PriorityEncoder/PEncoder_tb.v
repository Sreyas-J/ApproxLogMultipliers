`timescale 1ns / 1ps

module PEncoder_tb;
    
    reg [7:0] A;
    wire [2:0] O;
    
    // Instantiate the PEncoder module
    PEncoder uut (
        .A(A),
        .out(O)
    );
    
    initial begin
        // Dump waves for GTKWave
        $dumpfile("pencoder_tb.vcd");
        $dumpvars(0, PEncoder_tb);
        
        // Monitor signals
        $monitor("Time=%0t A=%d O=%d", $time, A, O);
        
        // Apply test vectors
        A = 8'd0; #10; // Test case 1: All zeros
        A = 8'd1; #10; // Test case 2: Single 1 at LSB
        A = 8'd2; #10; // Test case 3: Single 1 at bit 1
        A = 8'd35; #10; // Test case 4: First three bits high
        A = 8'd64; #10; // Test case 5: Random middle bits
        A = 8'd128; #10; // Test case 6: Alternating bits
        A = 8'd250; #10; // Test case 7: All ones
        A = 8'd73; #10; // Test case 8: Single 1 at MSB
        
        // End simulation
        $finish;
    end
    
endmodule
