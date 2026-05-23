Method Signature:
method ElementWiseDivide(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be the same as the length of the input sequences
- Each element in the result sequence should be the quotient of the corresponding elements in the input sequences
- For each index i, if b[i] is zero, the corresponding result element should be zero (or handle division by zero as specified)