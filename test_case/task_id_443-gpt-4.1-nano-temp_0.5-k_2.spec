Method Signature:
method LargestNegative(s: array<int>) returns (maxNeg: int)

Postconditions_prompt:
- If there exists a negative number in the input array, the returned value is the largest among those negative numbers
    - If no negative numbers exist in the input array, the method returns a default value (e.g., 0 or a specified sentinel) or indicates the absence appropriately
    - The input array remains unchanged