Method Signature:
method ElementWiseDivision(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be the same as the length of the input sequences
- For each index i, the result[i] is equal to a[i] divided by b[i]
- The sequence b must not contain zero to avoid division by zero errors