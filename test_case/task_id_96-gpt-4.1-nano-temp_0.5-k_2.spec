Method Signature:
method NumberOfDivisors(n: int) returns (count: nat)

Postconditions_prompt:
- The returned count is the number of positive divisors of n
    - For each positive integer d, d divides n if and only if d is less than or equal to n and n % d == 0
    - count equals the total number of such divisors