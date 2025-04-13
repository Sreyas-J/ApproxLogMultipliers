#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define MAX_NUM (1 << 8)   // 8-bit input
#define MAX_NUM1 (1 << 7)  // For 7-bit shifting

unsigned char leadingBitPosition(unsigned char val) {    
    if (val == 0) return -1; // Edge case for zero
    return 7 - (__builtin_clz(val) - 24); // Adjust for 8-bit values
}

short ALM_SOA(short a, short b, unsigned short w) {
    if (a == 0 || b == 0) return 0;

    // Extract magnitude (only the lower 8 bits)
    unsigned char a_abs = abs(a) & 0xFF;
    unsigned char b_abs = abs(b) & 0xFF;

    unsigned char k_a = leadingBitPosition(a_abs);
    unsigned char x_a = a_abs << (7 - k_a);

    unsigned char k_b = leadingBitPosition(b_abs);
    unsigned char x_b = b_abs << (7 - k_b);

    unsigned char tmp = (1 << 7) - 1;
    unsigned char tmp_prim = (1 << w) - 1;
    unsigned char tmp_sec = (1 << (w - 1));

    unsigned char y_a = x_a & tmp;
    unsigned char y_b = x_b & tmp;

    // Truncation
    unsigned char y_a_trunc = (tmp - tmp_prim) & y_a;
    unsigned char y_b_trunc = (tmp - tmp_prim) & y_b;

    unsigned char carry_in = ((y_a & y_b) & (tmp_sec)) * 2;
    unsigned char y_l = (y_a_trunc + y_b_trunc + carry_in) | tmp_prim;

    unsigned char k_l = k_a + k_b + (((y_l) & (tmp + 1)) >> 7);
    y_l = y_l & tmp;

    double m = (double)y_l / (1 << 7);
    short p_abs = (short)((1 + m) * (1 << k_l));

    return p_abs; // Final result uses only magnitude
}

int main() {
    short x[] = {-256, -130, 100, -64, 38, -200, -16, 255, -128, 50};
    short y[] = {-200, 10, 150, 0, 27, 33, -12, 1, -1, 25};
    int i;
    short p;
    unsigned short w = 3;

    FILE *log = fopen("mult_log_9bit.txt", "w");
    for (i = 0; i < 10; i++) {
        p = ALM_SOA(x[i], y[i], w);
        printf("x = %d, y = %d, p = %d, exact = %d\n", x[i], y[i], p, abs(x[i]) * abs(y[i]));
        fprintf(log, "x = %d, y = %d, p = %d, exact = %d\n", x[i], y[i], p, abs(x[i]) * abs(y[i]));
    }

    fclose(log);
    return 0;
}
