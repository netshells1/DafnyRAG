Method Signature:
method SumEvenNumbersAtEvenPositions(a: array<int>) returns (sum: int)

Postconditions_prompt:
- The output sum is equal to the sum of all even numbers located at even indices (0-based) in the input array
    - For every index i in the input array, if i is even and a[i] is even, then a[i] contributes to the sum
    - The sum only includes numbers at even positions and only those that are even themselves