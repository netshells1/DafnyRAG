Method Signature:
method ElementWiseDivide(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be equal to the length of input sequences a and b
- For each index i, if b[i] ≠ 0, then result[i] = a[i] / b[i]
- The method must handle division by zero appropriately (e.g., by defining the result at such positions or requiring b to contain no zeros)