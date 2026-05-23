Method Signature:
method ExtractElementwiseAndSequence(a: seq<int>, b: seq<int>) returns (elementwise: seq<int>, sequence: seq<int>)

Postconditions_prompt:
- The length of elementwise should be equal to the length of the shorter input sequence
- For each index i within the length of elementwise, elementwise[i] equals a[i] if i is within the bounds of a, otherwise b[i]
- The sequence should contain all elements from both input sequences in order, concatenated
- The length of sequence should be equal to the sum of the lengths of a and b