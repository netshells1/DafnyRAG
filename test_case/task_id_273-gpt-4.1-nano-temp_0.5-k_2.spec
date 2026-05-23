Method Signature:
method SequenceElementwiseSubtract(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be equal to the length of the input sequences
- For each index i within the bounds of the sequences, result[i] should be equal to a[i] minus b[i]
- The result sequence should contain the element-wise difference of the input sequences at each corresponding position