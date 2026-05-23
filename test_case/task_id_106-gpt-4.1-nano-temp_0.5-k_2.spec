Method Signature:
method AppendArrayToSequence(a: array<int>, s: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The resulting sequence is equal to the concatenation of the original sequence s and the sequence formed from the array a
    - The original array a remains unchanged after the method execution