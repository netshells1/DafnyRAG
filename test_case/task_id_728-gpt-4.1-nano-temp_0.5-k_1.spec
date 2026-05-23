Method Signature:
method ElementWiseSum(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence is equal to the length of input sequences a and b
    - For all indices i within the bounds of the sequences, result[i] equals a[i] + b[i]