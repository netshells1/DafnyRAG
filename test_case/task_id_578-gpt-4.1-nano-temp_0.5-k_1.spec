Method Signature:
method InterleaveThreeSequences(s1: seq<int>, s2: seq<int>, s3: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be three times the length of each input sequence
- The result sequence should contain all elements of s1, s2, and s3 in an interleaved manner, preserving the order of elements within each input sequence
- The elements from s1, s2, and s3 should appear in the result sequence in a repeating pattern corresponding to their original order