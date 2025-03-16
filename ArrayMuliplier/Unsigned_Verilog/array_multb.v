`timescale 1ns / 1ps

module array_multb;

    // Inputs
    reg  [3:0] a;
    reg  [3:0] b;

    // Outputs
    wire [7:0] s;

    // Expected Output for verification
    reg  [7:0] expected;

    // Instantiate the Unit Under Test (UUT)
    array_mul uut (
        .a(a), 
        .b(b), 
        .s(s)
    );

    initial begin
        // Initialize waveform dump for GTKWave (optional)
        $dumpfile("dump.vcd");
        $dumpvars(0, array_multb);

        // Print Header
        $display("Time  |  a (bin)  |  b (bin)  |  s (output)  | Expected  | Pass/Fail");
        $display("-------------------------------------------------------------");

        // Test Cases
        repeat (10) begin
            a = $random % 16;  // Generate random 4-bit number
            b = $random % 16;  // Generate random 4-bit number
            expected = a * b;  // Expected result

            #10; // Wait for output propagation

            // Print results
            $display("%4t  |  %b  |  %b  |  %b  |  %b  |  %s", 
                     $time, a, b, s, expected, (s == expected) ? "PASS" : "FAIL");
        end

        // End simulation
        $finish;
    end
endmodule
