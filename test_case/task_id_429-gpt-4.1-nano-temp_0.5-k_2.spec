Method Signature:
method ElementwiseSequence(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be equal to the length of the shorter input sequence
- Each element in the result sequence is the elementwise sum of the corresponding elements in sequences a and b
- If one sequence is shorter, only the elements up to the length of the shorter sequence are processed
- The order of elements in the result sequence corresponds to the order of the input sequences