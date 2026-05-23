Method Signature:
method DeepCopySequence(s: seq<int>) returns (copy: seq<int>)

Postconditions_prompt:
- The output sequence is equal to the input sequence in terms of elements
- The output sequence is a new sequence, not referencing the original sequence
- The length of the output sequence is the same as the input sequence