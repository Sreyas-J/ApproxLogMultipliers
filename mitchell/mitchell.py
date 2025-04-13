import math
import numpy as np

class Log:
    def __init__(self, k, x):
        self.k = k
        self.x = x

def compute_log(n):
    if n == 0:
        return Log(0, 0.0)
    
    magnitude = abs(n)
    
    # Calculate leading zeros for 8-bit numbers
    lz = 8 - len(bin(magnitude)[2:])
    k = 7 - lz
    
    if k < 0:
        return Log(0, 0.0)
    
    x = (magnitude / (1 << k)) - 1.0
    
    return Log(k, x)

def approxMultiply(a, b):
    if a == 0 or b == 0:
        return 0
    
    # Handle signs
    sign_a = a < 0
    sign_b = b < 0
    result_sign = sign_a != sign_b
    
    # Compute logarithms
    log_a = compute_log(a)
    log_b = compute_log(b)
    
    # Sum characteristics and mantissas
    k1 = log_a.k
    k2 = log_b.k
    x1 = log_a.x
    x2 = log_b.x
    
    x_sum = x1 + x2
    
    # Apply Mitchell's formula based on sum of mantissas
    if x_sum < 1.0:
        result = int((1 << (k1 + k2)) * (1.0 + x_sum))
    else:
        result = int((1 << (1 + k1 + k2)) * (x_sum))
    
    return -result if result_sign else result

# test_cases = [[-27, 119], [15, 5], [20, 4], [8, 2], [50, 7], [25, 6], [0, 18], [1, 1], [129, 65], [255, 255]]

# for a, b in test_cases:
#     exact = a * b
#     mitchell_result = approxMultiply(a, b)
    
#     print(f"Multiplying {a} × {b}")
#     print(f"  Mitchell Approximation: {mitchell_result}")
    
#     if exact != 0:
#         error = 100.0 * (mitchell_result - exact) / exact
#         print(f"  Error: {error}%\n")
#     else:
#         print("\n")