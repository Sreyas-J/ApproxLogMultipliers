#include <iostream>
#include <bit>   // For std::countl_zero (C++20)
#include <cmath> // For std::abs
#include <bitset>

using namespace std;

// Structure to hold the logarithm components
struct Log {
    int k;    // Characteristic (exponent)
    float x;  // Mantissa (fractional part)
};

// Compute approximate binary logarithm of an 8-bit magnitude with sign bit
Log compute_log(int n) {
    if (n == 0) return {0, 0.0f}; // Handle zero case
    
    // Extract magnitude (8 bits)
    uint8_t magnitude = abs(n);
    
    int lz = __builtin_clz(static_cast<uint32_t>(magnitude)) - 24; // Ensure correct leading zero count for 8-bit numbers
    int k = 7 - lz;
    
    if (k < 0) return {0, 0.0f}; // Edge case for very small numbers

    float x = (static_cast<float>(magnitude) / (1 << k)) - 1.0f; // Mantissa calculation

    return {k, x};
}

// Mitchell logarithmic multiplication for 9-bit signed numbers (8-bit magnitude + 1 sign bit)
int mitchell_multiply(int a, int b) {
    if (a == 0 || b == 0) return 0; // Handle zero multiplication

    // Handle signs
    bool sign_a = a < 0;
    bool sign_b = b < 0;
    bool result_sign = sign_a != sign_b;
    
    // Compute logarithms
    Log log_a = compute_log(a);
    Log log_b = compute_log(b);

    // Sum characteristics and mantissas
    int k1 = log_a.k;
    int k2 = log_b.k;
    float x1 = log_a.x;
    float x2 = log_b.x;
    
    float x_sum = x1 + x2;
    int result;
    
    // Apply Mitchell's formula based on sum of mantissas
    if (x_sum < 1.0f) {
        // p' = 2^(k1+k2) * (1 + x1 + x2)
        result = static_cast<int>((1 << (k1 + k2)) * (1.0f + x_sum));
    } else {
        // p' = 2^(1+k1+k2) * (x1 + x2)
        result = static_cast<int>((1 << (1 + k1 + k2)) * (x_sum));
    }

    cout<<"L: "<< bitset<11>(result)<<" op1: "<<bitset<11>(x1);
    return result_sign ? -result : result;
}

int main() {
    // Example test cases
    int test_cases[][2] = {{-27, 119}, {15, 5}, {20, 4}, {8, 2}, {50, 7}, {25, 6}, {0, 18}, {1, 1},{129,65},{255,255}};
    
    for (auto& tc : test_cases) {
        int a = tc[0], b = tc[1];
        int exact = a * b;
        int mitchell_result = mitchell_multiply(a, b);
        float error = 100.0f * (mitchell_result - exact) / exact;

        cout << "Multiplying " << a << " × " << b;
        // cout << "  Exact: " << exact << "\n";
        cout << "  Mitchell Approximation: " << mitchell_result << "\n";
        // cout << "  Error: " << error << "%\n\n";
    }
    
    return 0;
}