`timescale 1ns / 1ps

module ILM_tb;

    // Inputs (8-bit unsigned)
    reg [8:0] in1, in2;
    
    // Outputs
    wire [16:0] product;
    wire carry;

    // Intermediate signals for signed values
    integer signed_in1, signed_in2, signed_product;

    // Instantiate the ILM module
    ILM uut (
        .in1(in1), 
        .in2(in2), 
        .product(product),
        .carry(carry)
    );
    
    // Test cases
    initial begin
        // Enable waveform dumping for GTKWave
        $dumpfile("ILM_tb.vcd");  // Name of the VCD file
        $dumpvars(0, ILM_tb);      // Dump all variables in this module

        // Monitor output
        $monitor("Time = %0t | in1 = %d, in2 = %d | Product = %d", 
                 $time, signed_in1, signed_in2, signed_product);
        
        // Apply test cases (8-bit unsigned numbers)
        in1 = -9'd8;  in2 = 9'd9;  #10;
        in1 = 9'd15; in2 = 8'd5;  #10;
        in1 = 9'd20; in2 = 8'd4;  #10;
        in1 = 9'd8;  in2 = 8'd2;  #10;
        in1 = 9'd50; in2 = 8'd7;  #10;
        in1 = 9'd25; in2 = 8'd6;  #10;
        in1 = 9'd129; in2 = 8'd65;  #10;
        in1 = 9'd0;  in2 = 8'd18; #10;
        in1 = 9'd1;  in2 = 8'd1;  #10;
        in1 = 9'd255; in2 = 8'd255; #10;

        // End simulation
        $finish;
    end

    // Always block to update signed values
    always @(*) begin
        signed_in1 = $signed(in1);
        signed_in2 = $signed(in2);
        signed_product = $signed(product);
    end
    
endmodule
