Method Signature:
method ExtractElementwiseAndSequence(s1: seq<int>, s2: seq<int>) returns (elements: seq<int>, sequence: seq<int>)

Postconditions_prompt:
- The 'elements' sequence should contain all elements from 's1' and 's2' that are equal at the same index
- The 'sequence' should be a sequence of pairs (tuples) where each pair consists of elements from 's1' and 's2' at the same position
- The length of 'elements' and 'sequence' should be equal to the minimum length of 's1' and 's2'