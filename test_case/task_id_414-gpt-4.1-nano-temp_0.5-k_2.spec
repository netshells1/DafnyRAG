Method Signature:
method ExistsInSequence(seq1: seq<int>, seq2: seq<int>) returns (result: bool)

Postconditions_prompt:
- If the method returns true, there exists at least one value in seq1 that also appears in seq2
- If the method returns false, no value in seq1 exists in seq2