`timescale 1ns/1ps

module wallaceTreeMultiplier8Bit_tb;
    // Inputs
    reg [7:0] a;
    reg [7:0] b;
    
    // Outputs
    wire [15:0] result;
    
    // Expected output for verification
    reg [15:0] expected_result;
    
    wallaceTreeMultiplier8Bit uut (
        .result(result),
        .a(a),
        .b(b)
    );
    
    integer errors = 0;
    integer tests = 0;
    
    initial begin
    	$dumpfile("wallace_tree_multiplier_tb.vcd");
        $dumpvars(0, wallaceTreeMultiplier8Bit_tb);
        // Initialize inputs
        a = 0;
        b = 0;
        
        #100;
        
        // Test cases
        // Test Case 1: 0 * 0 = 0
        a = 8'd0; b = 8'd0;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 2: 1 * 1 = 1
        a = 8'd1; b = 8'd1;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 3: 7*5=35
        a = 8'd5; b = 8'd7;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 4: 15*16=240
        a = 8'd15; b = 8'd16;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 5: 255 * 1=255
        a = 8'd255; b = 8'd1;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 6: 255 * 2=510
        a = 8'd255; b = 8'd2;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 7: 255*255=65025
        a = 8'd255; b = 8'd255;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 8: 123*45=5535
        a = 8'd123; b = 8'd45;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 9: 200*100=20000
        a = 8'd200; b = 8'd100;
        expected_result = a * b;
        #10;
        verify_result;
        
        // Test Case 10: 85*85=7225
        a = 8'd85; b = 8'd85;
        expected_result = a * b;
        #10;
        verify_result;
        
        if (errors != 0) begin
            $display("TESTBENCH FAILED! %0d out of %0d tests failed.", errors, tests);
        end
        
        $finish;
    end
    
    // Task to verify the result against expected value
    task verify_result;
    begin
        tests = tests + 1;
        if (result !== expected_result) begin
            $display("ERROR at time %0t: a=%0d, b=%0d, result=%0d, expected=%0d", 
                     $time, a, b, result, expected_result);
            errors = errors + 1;
        end else begin
            $display("PASS at time %0t: a=%0d, b=%0d, result=%0d", 
                     $time, a, b, result);
        end
    end
    endtask
    
endmodule
