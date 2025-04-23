import math
import numpy as np
np.random.seed(3)
def logmult(A, B, K):
    
    
    sign1 = 1
    sign2 = 1
    
    if A < 0:
        sign1 = -1
        A = -A
    
    if B < 0:
        sign2 = -1
        B = -B
    
    def nearest_power_of_two(N):
        if N <= 0:
            return 0
                
        k = math.floor(math.log2(N))
        lower_power = 2 ** k
        
        upper_power = 2 ** (k + 1)
        
        if N - lower_power < upper_power - N:
            return lower_power
        else:
            return upper_power

    two_p_k1 = nearest_power_of_two(A)
    two_p_k2 = nearest_power_of_two(B)
    
    if two_p_k1 == 0 and two_p_k2 == 0:
        k1 = 0
        k2 = 0
    elif two_p_k1 == 0:
        k1 = 0
        k2 = int(math.log2(two_p_k2))
    elif two_p_k2 == 0:
        k1 = int(math.log2(two_p_k1))
        k2 = 0
    elif two_p_k1 and two_p_k2:
        k1 = int(math.log2(two_p_k1))
        k2 = int(math.log2(two_p_k2))
    
    q1 = A - two_p_k1
    q2 = B - two_p_k2
    
    pp1 = q1 * (2 ** k2)
    pp2 = q2 * (2 ** k1)
    
    dec_out = (2 ** (k1 + k2))

    def number_to_binary_list(n):
        return [int(bit) for bit in bin(n)[2:]]

    def add_binary_lists(a, b):
        max_len = max(len(a), len(b))
        a = [0] * (max_len - len(a)) + a
        b = [0] * (max_len - len(b)) + b

        result = []
        carry = 0

        for i in range(max_len - 1, -1, -1):
            total = a[i] + b[i] + carry
            result.append(total % 2)
            carry = total // 2

        if carry:
            result.append(carry)

        return result[::-1]


    def approx_add(num1, num2, k):
        # For signed 14-bit inputs, the range is -16384 to 16383
        
        # Perform regular addition
        total = num1 + num2
        
        # Store the sign for the final result
        is_negative = total < 0
        total_abs = abs(total)
        
        # Now replace the K LSBs with alternating 1 and 0 pattern
        # First, clear the K LSBs
        mask = ~((1 << k) - 1)
        result_abs = total_abs & mask
        
        # Then set alternating 1,0,1,0... pattern for K LSBs
        for i in range(k):
            if i % 2 == 0:  # Even positions get 1
                result_abs |= (1 << i)
            # Odd positions remain 0
        
        # Apply sign for final result
        result = -result_abs if is_negative else result_abs
        
        return result


    
    approx_adder = approx_add(pp1 , pp2,K)
    # if(approx_adder!=pp1+pp2):
        # print(pp1,pp2,approx_adder)
    # approx_adder = pp1+pp2
    product = dec_out + approx_adder
    product = sign1 * sign2 * product
    
    return product

# A = np.random.randint(low=0, high=255, size=10**6)
# B = np.random.randint(low=0, high=255, size=10**6)
# for i in range(len(A)):
#     out = logmult(A[i], B[i],9)