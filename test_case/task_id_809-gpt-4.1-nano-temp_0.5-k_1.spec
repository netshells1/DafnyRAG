Method Signature:
method AllSecondSmallerThanFirst(seq1: seq<int>, seq2: seq<int>) returns (result: bool)

Postconditions_prompt:
- The result is true if and only if for all indices i within the length of seq2, seq2[i] < seq1[i]
- The input sequences remain unchanged