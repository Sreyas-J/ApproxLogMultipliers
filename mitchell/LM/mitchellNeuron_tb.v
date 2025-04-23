`timescale 1ns/1ps

module tb_artificial_neuron;
    // Testbench signals
    reg signed [7:0] x1, x2, x3;
    wire signed [7:0] y;

    // Instantiate the artificial neuron
    artificial_neuron uut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );

    initial begin
        // Test vector 1: all zeros
        x1 = 0; x2 = 0; x3 = 0; #10;
        // Test vector 2: small positive inputs
        x1 = 1; x2 = 1; x3 = 1; #10;

        // Test vector 3: small negative inputs
        x1 = -1; x2 = -1; x3 = -1; #10;

        // Test vector 4: saturation positive
        x1 = 2; x2 = 0; x3 = 2; #10;

        // Test vector 5: saturation negative
        x1 = -4; x2 = 0; x3 = 0; #10;

        // Random test vectors
        repeat (5) begin
            x1 = $random;
            x2 = $random;
            x3 = $random;
            #10;
        end

        $finish;
    end
endmodule
