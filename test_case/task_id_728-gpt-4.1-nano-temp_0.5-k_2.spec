Method Signature:
method ElementWiseAdd(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence is equal to the length of input sequences a and b
    - For all indices i within the length of a and b, result[i] equals a[i] + b[i]
    - The result sequence contains the element-wise sum of the input sequences