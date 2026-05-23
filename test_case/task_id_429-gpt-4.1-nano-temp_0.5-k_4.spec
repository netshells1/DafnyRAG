Method Signature:
method ElementwiseSequence(a: seq<int>, b: seq<int>) returns (result: seq<seq<int>>)

Postconditions_prompt:
- The result sequence contains exactly two sequences
- The first sequence in the result is equal to the sequence of elements from 'a'
- The second sequence in the result is equal to the sequence of elements from 'b'