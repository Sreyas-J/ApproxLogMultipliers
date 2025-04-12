`timescale 1ns / 1ps

module ILM_tb;

    // Parameters for the test
    integer i;
    real error_count = 0;
    real total_error_distance = 0; // To accumulate the error distances
    real error_ratio = 0;          // For relative error accumulation
    real total_tests = 10000000;   // Total tests to run
    real valid_tests;              // Valid tests counter (initialized in initial block)
    real max_error=0;
    real error_distance; // Temporary variable for each error distance
    real MED;

    // Testbench signals
    reg [8:0] X,Y;
    reg [15:0] accurate_p;
    wire [16:0] product;

    // Instantiate the HOERAA module
    ILM uut (
        .in1(X), 
        .in2(Y), 
        .product(product),
        .carry(carry)
    );

    // Task to perform accurate addition to compute expected values
    task accurate_mul;
        input [8:0] A, B;
        output [16:0] prod;
        // output carry_out;
        reg [16:0] temp_result;
        begin
            temp_result[15:0] = A[7:0] * B[7:0];
            prod = temp_result[15:0];
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
            X = $random;
            Y = $random;

            // Calculate the expected accurate result
            accurate_mul(X, Y, accurate_p);

            // Wait for a small delay to simulate processing time
            #10;

            // Calculate the error distance (absolute difference between accurate and approximate sum)
            error_distance = (product[15:0] > accurate_p) ? (product[15:0] - accurate_p) : (accurate_p - product[15:0]);
            if(error_distance> max_error) max_error=error_distance;
            total_error_distance = total_error_distance + error_distance;

            // Calculate the relative error if accurate_p is non-zero
            if (accurate_p != 0) begin
                error_ratio = error_ratio + (error_distance) / accurate_p;
            end else begin
                valid_tests = valid_tests - 1; // Decrement valid tests for zero `accurate_p`
            end

            // Check if the HOERAA output matches the accurate result
            if (product !== accurate_p) begin
                error_count = error_count + 1;
            end
        end

        MED=total_error_distance / total_tests;
        // Final Error Rate and MED after all tests
        $display("Final Error Rate after %0d tests: %0.2f%%", total_tests, (error_count * 100.0) / total_tests);
        $display("Final Mean Error Distance (MED) after %0d tests: %0.2f", total_tests,MED) ;
        $display("Final Mean Relative Error Distance (MRED) after %0d tests: %0.2f", total_tests, error_ratio / valid_tests);
        $display("Final Normalized Mean Error Distancee (NMED) after %0d tests: %0.2fx10^-3",total_tests, (MED/max_error)*1000);

        // End simulation
        $finish;
    end

endmodule
