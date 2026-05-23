Method Signature:
method SubtractSequences(s1: seq<int>, s2: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be equal to the length of s1 and s2
- Each element in the result sequence is the difference between the corresponding elements of s1 and s2
- For all valid indices i, result[i] == s1[i] - s2[i]