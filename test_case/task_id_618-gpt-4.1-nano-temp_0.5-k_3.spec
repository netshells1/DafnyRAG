Method Signature:
method ElementWiseDivide(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be equal to the length of the input sequences
- Each element in the result sequence should be the quotient of the corresponding elements in the input sequences
- The divisor sequence should not contain zero at any position where division occurs (to avoid division by zero)