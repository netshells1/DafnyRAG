Method Signature:
method IsSumOfNonZeroPowersOfTwo(n: int) returns (result: bool)

Postconditions_prompt:
- The result is true if and only if the input number n can be expressed as the sum of one or more non-zero powers of 2
    - If result is true, then n > 0 and there exists a subset of positive integers k such that n = sum of 2^k for each k in the subset
    - If result is false, then n cannot be expressed as such a sum