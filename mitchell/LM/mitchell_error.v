`timescale 1ns / 1ps

module mitchell_tb;

    // Parameters for the test
    integer i;
    real error_count = 0;
    real total_error_distance = 0; // To accumulate the error distances
    real error_ratio = 0;          // For relative error accumulation
    real total_tests = 1000000;   // Total tests to run
    real valid_tests;              // Valid tests counter (initialized in initial block)
    real max_error=0;
    real error_distance; // Temporary variable for each error distance
    real MED;

    // Testbench signals
    reg [8:0] X,Y;
    reg [16:0] accurate_p;
    wire [16:0] product;

    // Instantiate the HOERAA module
    MITCHEL uut (
        .x(X), 
        .y(Y), 
        .p(product)
    );

    // Task to perform accurate addition to compute expected values
    task accurate_mul;
        input [8:0] A, B;
        output reg [16:0] prod;  // Make sure output is signed too
        begin
            prod = A * B;  // Signed multiplication
        end
    endtask

    // Test procedure
    initial begin
        // Initialize variables
        error_count = 0;
        total_error_distance = 0;
        error_ratio = 0;
        valid_tests = total_tests; // Set valid_tests initially to total_tests

        // Run the specified number of tests
        for (i = 0; i < total_tests; i = i + 1) begin
            // Generate random inputs for X and Y
            X = $unsigned($random) % 256;
            Y = $unsigned($random) % 256;

            // Calculate the expected accurate result
            accurate_mul(X, Y, accurate_p);

            // Wait for a small delay to simulate processing time
            #10;

            // Calculate the error distance (absolute difference between accurate and approximate sum)
            error_distance = (product > accurate_p) ? (product - accurate_p) : (accurate_p - product);
            if(error_distance> max_error) max_error=error_distance;
            total_error_distance = total_error_distance + error_distance;

            // Calculate the relative error if accurate_p is non-zero
            if (accurate_p != 0) begin
                error_ratio = error_ratio + (error_distance) / accurate_p;
            end else begin
                valid_tests = valid_tests - 1; // Decrement valid tests for zero `accurate_p`
            end

            // $display("X:%d Y:%d p:%d acc_p:%d error:%d",X,Y,product, accurate_p,error_distance);
        end

        MED=total_error_distance / total_tests;
        // Final Error Rate and MED after all tests
        // $display("Final Error Rate after %0d tests: %0.2f%%", total_tests, (error_count * 100.0) / total_tests);
        $display("Final Average Error (AE) after %0d tests: %0.4f", total_tests,MED) ;
        $display("Final Mean Relative Error Distance (MRED) after %0d tests: %0.4f", total_tests, error_ratio / valid_tests);
        $display("Final Normalized Mean Error Distancee (NMED) after %0d tests: %0.4f",total_tests, MED/max_error);

        // End simulation
        $finish;
    end

endmodule
