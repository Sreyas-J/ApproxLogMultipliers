`timescale 1ns / 1ps

module MITCHEL_tb;

    // Inputs (8-bit unsigned)
    reg [8:0] x, y;
    
    // Outputs
    wire [16:0] p;
    // wire [7:0] LODa,LODb,A,B;
    // wire [2:0] kA, kB;
    // wire [10:0] op1, op2, L;
    // wire [15:0] tmp_out;

    // Intermediate signals for signed values
    // integer signed_in1, signed_in2, signed_product;

    // Instantiate the ILM module
    MITCHEL uut (
        .x(x), 
        .y(y), 
        .p(p)

        // .A(A),
        // .B(B),
        // .LODa(LODa),
        // .LODb(LODb),
        // .kA(kA), 
        // .kB(kB),
        // .op1(op1),
        // .op2(op2),
        // .L(L),
        // .tmp_out(tmp_out)
    );
    
    // Test cases
    initial begin
        // Enable waveform dumping for GTKWave
        $dumpfile("MITCHEL_tb.vcd");  // Name of the VCD file
        $dumpvars(0, uut);      // Dump all variables in this module

        // Monitor output
        $monitor("Time = %0t | x = %b (%d), y = %b (%d) | Product = %b (%d)", 
                 $time, x,x, y,y , p, p);
        
        // Apply test cases (8-bit unsigned numbers)
                // Test Case 1: 5 * 3
        x = 9'b000000101;  y = 9'b000000011;  #10;
        
        // Test Case 2: 15 * 5
        x = 9'b000001111;  y = 9'b000000101;  #10;
        
        // Test Case 3: 20 * 4
        x = 9'b000010100;  y = 9'b000000100;  #10;
        
        // Test Case 4: 8 * 2
        x = 9'b000001000;  y = 9'b000000010;  #10;
        
        // Test Case 5: 50 * 7
        x = 9'b000110010;  y = 9'b000000111;  #10;
        
        // Test Case 6: 25 * 6
        x = 9'b000011001;  y = 9'b000000110;  #10;
        
        // Test Case 7: 129 * 65
        x = 9'b010000001;  y = 9'b001000001;  #10;
        
        // Test Case 8: 0 * 18
        x = 9'b000000000;  y = 9'b000010010;  #10;
        
        // Test Case 9: 1 * 1
        x = 9'b000000001;  y = 9'b000000001;  #10;
        
        // Test Case 10: 253 * 253
        x = 9'b011111101;  y = 9'b011111101;  #10;



                // Test Case 1: 5 * 3
        x = 9'b100000101;  y = 9'b000000011;  #10;
        
        // Test Case 2: 15 * 5
        x = 9'b000001111;  y = 9'b100000101;  #10;
        
        // Test Case 3: 20 * 4
        x = 9'b100010100;  y = 9'b100000100;  #10;
        
        // Test Case 4: 8 * 2
        x = 9'b100001000;  y = 9'b000000010;  #10;
        
        // Test Case 5: 50 * 7
        x = 9'b000110010;  y = 9'b100000111;  #10;
        
        // Test Case 6: 25 * 6
        x = 9'b100011001;  y = 9'b100000110;  #10;
        
        // Test Case 7: 129 * 65
        x = 9'b110000001;  y = 9'b001000001;  #10;
        
        // Test Case 8: 0 * 18
        x = 9'b000000000;  y = 9'b000010010;  #10;
        
        // Test Case 9: 1 * 1
        x = 9'b000000001;  y = 9'b100000001;  #10;
        
        // Test Case 10: 253 * 253
        x = 9'b111111101;  y = 9'b111111101;  #10;

        // End simulation
        $finish;
    end

    // Always block to update signed values
    // always @(*) begin
    //     signed_in1 = $signed(x);
    //     signed_in2 = $signed(y);
        // signed_product = $signed(p);
    // end
    
endmodule
