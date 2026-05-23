Method Signature:
method ElementWiseDivide(a: array<int>, b: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The length of the result array should be the same as the length of the input arrays
- Each element in the result array should be the quotient of the corresponding elements in the input arrays
- The divisor elements in the input array b should not be zero to avoid division by zero errors