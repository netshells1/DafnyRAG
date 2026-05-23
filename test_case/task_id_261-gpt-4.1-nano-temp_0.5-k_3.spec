Method Signature:
method ElementWiseDivision(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be the same as the length of the input sequences
- For each index i, the result[i] should be equal to a[i] divided by b[i], assuming b[i] ≠ 0
- The method should handle division by zero appropriately (e.g., by requiring b[i] ≠ 0 for all i)