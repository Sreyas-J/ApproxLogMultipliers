`timescale 1ns / 1ps

module ALM_SOA_tb;

    // Inputs (8-bit unsigned)
    reg [8:0] x, y;
    
    // Outputs
    wire [16:0] p;
    // wire [7:0] LODa,LODb,A,B;
    // wire [2:0] kA, kB;
    // wire [10:0] op1, op2, L;
    // wire [15:0] tmp_out;
    // wire prod_sign;

    // Intermediate signals for signed values
    // integer signed_in1, signed_in2, signed_product;
    reg [16:0] signed_product;
    // Instantiate the ILM module
    ALM_SOA uut (
        .x(x), 
        .y(y), 
        .p(p)
        // .prod_sign(prod_sign),
        // .tmp_out(tmp_out),

        // .A(A),
        // .B(B)
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
        $dumpfile("ALM_SOA_tb.vcd");  // Name of the VCD file
        $dumpvars(0, uut);      // Dump all variables in this module

        // Monitor output
        $monitor("Time = %0t | x = %b (%d), y = %b (%d) | Product = %b (%d)", 
                 $time, x,x, y,y , p,signed_product);
        
        // Apply test cases (8-bit unsigned numbers)
                // Test Case 1: 5 * 3
        x = 9'd5;  y = 9'd3;  #10;
        x = 9'd15; y = 9'd5;  #10;
        x = 9'd20; y = 9'd4;  #10;
        x = 9'd8;  y = 9'd2;  #10;
        x = 9'd50; y = 9'd7;  #10;
        x = 9'd25; y = 9'd6;  #10;
        x = 9'd129; y = 9'd65;  #10;
        x = 9'd0;  y = 9'd18; #10;
        x = 9'd1;  y = 9'd1;  #10;
        x = 9'd255; y = 9'd255; #10;
        x= 9'd30; y=9'd68; #10

        // x = -9'd5;  y = 9'd3;  #10;
        // x = 9'd15; y = -9'd5;  #10;
        // x = -9'd20; y = -9'd4;  #10;
        // x = -9'd8;  y = 9'd2;  #10;
        // x = 9'd50; y = -9'd7;  #10;
        // x = -9'd25; y = -9'd6;  #10;
        // x = -9'd129; y = 9'd65;  #10;
        // x = 9'd0;  y = -9'd18; #10;
        // x = -9'd1;  y = -9'd1;  #10;
        // x = -9'd255; y = 9'd255; #10;

        // End simulation
        $finish;
    end
    always @(*) begin
        signed_product=({17{p[16]}}^p)+p[16];
    end   
endmodule