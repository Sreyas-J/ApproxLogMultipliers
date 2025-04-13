import math
import numpy as np

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

np.random.seed(3)
def logmult(A, B, K=0):
    
    
    sign1 = 1
    sign2 = 1
    
    if A < 0:
        sign1 = -1
        A = -A
    
    if B < 0:
        sign2 = -1
        B = -B
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


    def approx_add(num1, num2, k=0):
        # Ensure inputs are 14-bit numbers
        a = num1 & 0x3FFF  # 0x3FFF = 14 bits of 1s (16383 in decimal)
        b = num2 & 0x3FFF
        
        # Initialize result and carry
        result = 0
        carry = 0
        
        # Process bit by bit (15 bits to handle potential carry)
        for i in range(15):
            if i < k:
                # For the K LSBs, set alternating 1 and 0 pattern (starting with 1)
                result |= ((i % 2) == 0) << i
            else:
                # For bits beyond K, perform normal binary addition with carry
                # For bit positions beyond the 14th bit of inputs, use 0
                bit_a = (a >> i) & 1 if i < 14 else 0
                bit_b = (b >> i) & 1 if i < 14 else 0
                
                # Calculate sum and new carry
                sum_bit = bit_a ^ bit_b ^ carry
                carry = (bit_a & bit_b) | (bit_a & carry) | (bit_b & carry)
                
                # Set the bit in result
                result |= (sum_bit << i)
        
        return result

    
    # approx_adder = approx_add(pp1 , pp2,0)
    approx_adder = pp1+pp2
    product = dec_out + approx_adder
    product = sign1 * sign2 * product
    
    return product

# meanAE = 0
# A = np.random.randint(low=0, high=255, size=10**6)
# B = np.random.randint(low=0, high=255, size=10**6)
# AE=0
# maxAE = 0
# MRED = 0
# NMED = 0
# c=0
# for i in range(len(A)):
#     out = logmult(A[i], B[i])
#     # print(out)
#     mod = abs(out-(A[i]*B[i]))
#     if(A[i]*B[i]==0):
#         MRED+=0
#     else:
#         MRED += abs((out-(A[i]*B[i]))/(A[i]*B[i]))
#         c+=1
#     maxAE = int(max(maxAE,abs(out-(A[i]*B[i]))))
#     AE+= out-(A[i]*B[i])
#     NMED += out - (A[i]*B[i])
# AE=abs(AE)/1000000
# MRED = MRED/c
# NMED = NMED/(1000000*maxAE)*100
# print(f"Absolute error: {AE}")
# print(f"MRED: {MRED}")
# print(f"NMED: {NMED}")


# A = 4
# B = 18
# K = 9
# Prod = logmult(A,B,K)
# print(f"{A}*{B}={Prod}")