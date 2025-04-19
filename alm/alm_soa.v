module ALM_SOA #(
    parameter W = 5,
    parameter N = 16,
    parameter TMP = (1 << (N-1)) - 1,      // 32767
    parameter TMP_PRIM = (1 << W) - 1,       // 7 for W=3
    parameter TMP_SEC  = (1 << (W-1))         // 4 for W=3
)(
    input  [8:0] x,
    input  [8:0] y,
    output reg [16:0] p
);

    wire x_neg, y_neg;
    assign x_neg = x[8];
    assign y_neg = y[8];

    wire [8:0] x_abs_raw = x_neg ? (~x + 9'd1) : x;
    wire [8:0] y_abs_raw = y_neg ? (~y + 9'd1) : y;

    wire [7:0] x_abs = (x_abs_raw > 9'd255) ? 8'd255 : x_abs_raw[7:0];
    wire [7:0] y_abs = (y_abs_raw > 9'd255) ? 8'd255 : y_abs_raw[7:0];

    wire zero_flag = (x_abs == 8'd0) || (y_abs == 8'd0);

    function [3:0] lead_pos;
        input [7:0] in;
        begin
            if (in[7])         lead_pos = 7;
            else if (in[6])    lead_pos = 6;
            else if (in[5])    lead_pos = 5;
            else if (in[4])    lead_pos = 4;
            else if (in[3])    lead_pos = 3;
            else if (in[2])    lead_pos = 2;
            else if (in[1])    lead_pos = 1;
            else               lead_pos = 0;
        end
    endfunction

    wire [3:0] k_a = (x_abs == 0) ? 4'd0 : lead_pos(x_abs);
    wire [3:0] k_b = (y_abs == 0) ? 4'd0 : lead_pos(y_abs);

    wire [15:0] x_a = x_abs << (5'd15 - k_a);
    wire [15:0] x_b = y_abs << (5'd15 - k_b);

    wire [14:0] y_a = x_a[14:0];
    wire [14:0] y_b = x_b[14:0];

    wire [14:0] y_a_trunc = (TMP - TMP_PRIM) & y_a;
    wire [14:0] y_b_trunc = (TMP - TMP_PRIM) & y_b;

    wire [14:0] carry_in = (((y_a & y_b) & TMP_SEC) != 0) ? (TMP_SEC << 1) : 0;

    wire [15:0] y_l_pre = {1'b0, y_a_trunc} + {1'b0, y_b_trunc} + {1'b0, carry_in};
    wire [15:0] y_l_full = y_l_pre | TMP_PRIM;
    wire [14:0] y_l = y_l_full[14:0];

    wire [4:0] k_l = k_a + k_b + (y_l_pre[15] ? 5'd1 : 5'd0);

    wire [31:0] numerator = ((16'd32768 + {1'b0, y_l}) << k_l);
    wire [16:0] p_abs = numerator >> 15;

    wire prod_sign = x_neg ^ y_neg;
    wire [16:0] p_signed = prod_sign ? (~p_abs + 17'd1) : p_abs;

    always @(*) begin
        if (zero_flag)
            p = 17'd0;
        else
            p = p_signed;
    end

endmodule
