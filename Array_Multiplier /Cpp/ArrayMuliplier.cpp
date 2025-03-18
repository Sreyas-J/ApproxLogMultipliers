#include <iostream>
#include <vector>
#include <bitset>

using namespace std;

// Function to implement an 8-bit Array Multiplier using full adder logic
uint16_t arrayMultiplier(uint8_t A, uint8_t B) {
    vector<vector<int>> partialProducts(8, vector<int>(8, 0));
    vector<vector<int>> sum(8, vector<int>(9, 0)); 
    uint16_t product = 0;

    // Step 1: Generate Partial Products (Hardware: AND Gates)
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            partialProducts[i][j] = ((A >> j) & 1) & ((B >> i) & 1);  // A[j] & B[i]
        }
    }

    // Step 2: Column-wise Summation (Hardware: Half Adders + Full Adders)
    for (int col = 0; col < 8; col++) { 
        int carry = 0;
        for (int row = 0; row <= col; row++) {  
            int sumVal = sum[row][col] + partialProducts[row][col] + carry;
            sum[row][col] = sumVal % 2;  // Store sum
            carry = sumVal / 2;          // Carry to next stage
        }
        sum[col + 1][col] = carry;       // Propagate carry
    }

    // Step 3: Construct Final Product (Hardware: Shift & OR)
    for (int i = 0; i < 16; i++) {
        int bitValue = (i < 8) ? sum[i][i] : sum[7][i - 8];  // Extract final sum
        product |= (bitValue << i);
    }

    return product;
}

// Function to print 8-bit binary representation
void printBinary(uint16_t num, int bits) {
    cout << bitset<16>(num).to_string().substr(16 - bits) << " ";
}

int main() {
    uint8_t A = 7;  
    uint8_t B = 3;  

    uint16_t result = arrayMultiplier(A, B);

    // Display results in 8-bit binary representation
    cout << "A      : "; printBinary(A, 8); cout << "( " << (int)A << " )\n";
    cout << "B      : "; printBinary(B, 8); cout << "( " << (int)B << " )\n";
    cout << "Product: "; printBinary(result, 16); cout << "( " << result << " )\n";

    return 0;
}
