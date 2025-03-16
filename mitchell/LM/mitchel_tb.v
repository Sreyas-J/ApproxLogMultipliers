`timescale 1ns / 1ps

module MITCHEL_tb;

    // Inputs (8-bit unsigned)
    reg [8:0] x, y;
    
    // Outputs
    wire [16:0] p;
    wire [7:0] LODa,LODb,A,B;
    wire [2:0] kA, kB;
    wire [10:0] op1, op2, L;
    wire [15:0] tmp_out;

    // Intermediate signals for signed values
    integer signed_in1, signed_in2, signed_product;

    // Instantiate the ILM module
    MITCHEL uut (
        .x(x), 
        .y(y), 
        .p(p),

        .A(A),
        .B(B),
        .LODa(LODa),
        .LODb(LODb),
        .kA(kA), 
        .kB(kB),
        .op1(op1),
        .op2(op2),
        .L(L),
        .tmp_out(tmp_out)
    );
    
    // Test cases
    initial begin
        // Enable waveform dumping for GTKWave
        $dumpfile("MITCHEL_tb.vcd");  // Name of the VCD file
        $dumpvars(0, uut);      // Dump all variables in this module

        // Monitor output
        $monitor("Time = %0t | x = %d, y = %d | Product = %d | A=%b | B=%b | LODa = %b | LODb=%b | kA = %b | kB = %b | op1 = %b | op2 = %b | L = %b | tmp_out = %b", 
                 $time, x, y, p,A,B,LODa,LODb,kA,kB,op1,op2,L,tmp_out);
        
        // Apply test cases (8-bit unsigned numbers)
        x = 9'd5;  y = 8'd3;  #10;
        x = 9'd15; y = 8'd5;  #10;
        x = 9'd20; y = 8'd4;  #10;
        x = 9'd8;  y = 8'd2;  #10;
        x = 9'd50; y = 8'd7;  #10;
        x = 9'd25; y = 8'd6;  #10;
        x = 9'd129; y = 8'd65;  #10;
        x = 9'd0;  y = 8'd18; #10;
        x = 9'd1;  y = 8'd1;  #10;
        x = 9'd255; y = 8'd255; #10;

        // End simulation
        $finish;
    end

    // Always block to update signed values
    always @(*) begin
        signed_in1 = $signed(x);
        signed_in2 = $signed(y);
        signed_product = $signed(p);
    end
    
endmodule
