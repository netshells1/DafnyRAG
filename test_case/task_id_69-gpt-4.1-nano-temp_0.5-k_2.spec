Method Signature:
method ContainsSequence(seqList: seq<seq<int>>, target: seq<int>) returns (result: bool)

Postconditions_prompt:
- If the result is true, then the target sequence is a subsequence of at least one sequence in seqList
- If the result is false, then the target sequence is not a subsequence of any sequence in seqList