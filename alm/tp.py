def leading_bit_position(val):
    if val == 0:
        return 0
    return val.bit_length() - 1

def alm_soa_signed(a, b, w):
    if a == 0 or b == 0:
        return 0

    # Clamp input to 9-bit signed range [-255, 255]
    a = max(min(a, 255), -255)
    b = max(min(b, 255), -255)

    n = 16  # for internal fixed-point ops

    # Get sign bits
    sgn_a = 1 if a < 0 else 0
    sgn_b = 1 if b < 0 else 0

    a_abs = -a if sgn_a else a
    b_abs = -b if sgn_b else b

    k_a = leading_bit_position(a_abs)
    x_a = a_abs << (n - 1 - k_a)

    k_b = leading_bit_position(b_abs)
    x_b = b_abs << (n - 1 - k_b)

    tmp = (1 << (n - 1)) - 1
    tmp_prim = (1 << w) - 1
    tmp_sec = (1 << (w - 1))

    y_a = x_a & tmp
    y_b = x_b & tmp

    y_a_trunc = (tmp - tmp_prim) & y_a
    y_b_trunc = (tmp - tmp_prim) & y_b

    carry_in = ((y_a & y_b) & tmp_sec) * 2
    y_l = (y_a_trunc + y_b_trunc + carry_in) | tmp_prim

    k_l = k_a + k_b + ((y_l & (tmp + 1)) >> (n - 1))
    y_l = y_l & tmp

    m = y_l / (1 << 15)
    p_abs = int((1 + m) * (1 << k_l))

    # Apply sign
    result = -p_abs if sgn_a ^ sgn_b else p_abs

    # Ensure 17-bit signed representation
    if result < 0:
        result = (abs(result) & 0x1FFFF) * -1
    else:
        result = result & 0x1FFFF

    return result

# Test inputs
x_vals = [-255, -130, 100, -64, 38, -200, -16, 255, -128, 50]
y_vals = [-200, 10, 150, 0, 27, 33, -12, 1, -1, 25]
w = 3

# Run and print
for i in range(len(x_vals)):
    approx = alm_soa_signed(x_vals[i], y_vals[i], w)
    exact = x_vals[i] * y_vals[i]
    print(f"x = {x_vals[i]:4}, y = {y_vals[i]:4} | ALM-SOA ≈ {approx:7} | Exact = {exact:7} | Error = {approx - exact:+5}")
