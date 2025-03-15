`timescale 1ns/1ps

module tb_signed_arrayMul;

  // Inputs and outputs
  reg  [3:0] a, b;
  wire [7:0] s;

  // Instantiate the design under test
  signed_arrayMul uut (
    .a(a),
    .b(b),
    .s(s)
  );

  // Dump waveforms for viewing (optional)
  initial begin
    $dumpfile("signed_arrayMul_wave.vcd");
    $dumpvars(0, tb_signed_arrayMul);
  end

  // Task to apply a test vector and check the result
  task test_vector;
    input [3:0] a_in, b_in;
    input [7:0] expected;
    begin
      a = a_in;
      b = b_in;
      #10; // wait for outputs to settle

      // Display results in a structured table format
      if (s !== expected)
        $display("| %8t |   %4b (%3d) |   %4b (%3d) |  %8b (%3d) | %8b (%3d) | ERROR", 
                  $time, a_in, $signed(a_in), b_in, $signed(b_in), s, $signed(s), expected, $signed(expected));
      else
        $display("| %8t |   %4b (%3d) |   %4b (%3d) |  %8b (%3d) | %8b (%3d) | PASS",
                  $time, a_in, $signed(a_in), b_in, $signed(b_in), s, $signed(s), expected, $signed(expected));
    end
  endtask

  // Apply a series of test vectors
  initial begin
    $display("Starting simulation...\n");

    // Display header
    $display("------------------------------------------------------------------");
    $display("| Time (ns) |   a (bin)  |   b (bin)  |  s (output)  | Expected   |");
    $display("------------------------------------------------------------------");

    // Test cases
    test_vector(4'b0000, 4'b0000, 8'b00000000); //  0 *  0 =  0
    test_vector(4'b0001, 4'b0001, 8'b00000001); //  1 *  1 =  1
    test_vector(4'b0010, 4'b0010, 8'b00000100); //  2 *  2 =  4
    test_vector(4'b0100, 4'b0011, 8'b00001100); //  4 *  3 = 12
    test_vector(4'b1010, 4'b0101, 8'b11100010); // -6 *  5 = -30
    test_vector(4'b1111, 4'b1111, 8'b00000001); // -1 * -1 =  1
    test_vector(4'b1100, 4'b1100, 8'b00010000); // -4 * -4 = 16
    test_vector(4'b0111, 4'b0111, 8'b00110001); //  7 *  7 = 49
    test_vector(4'b1001, 4'b0011, 8'b11101011); // -7 *  3 = -21

    // End simulation
    $display("------------------------------------------------------------------");
    $display("Simulation complete.");
    $finish;
  end

endmodule
