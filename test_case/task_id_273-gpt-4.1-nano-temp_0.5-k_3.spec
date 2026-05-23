Method Signature:
method ElementWiseSubtract(a: seq<int>, b: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be equal to the length of the input sequences
- Each element in the result sequence should be the difference between the corresponding elements of the input sequences (a[i] - b[i])
- The order of elements in the result sequence should match the order of the input sequence a
- The result sequence should contain only integers resulting from the subtraction operation