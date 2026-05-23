Method Signature:
method ContainsSequence(lst: seq<seq<int>>, seqToFind: seq<int>) returns (result: bool)

Postconditions_prompt:
- If the result is true, then the sequence seqToFind exists as a contiguous subsequence within at least one element of the list lst
- If the result is false, then the sequence seqToFind does not exist as a contiguous subsequence within any element of the list lst