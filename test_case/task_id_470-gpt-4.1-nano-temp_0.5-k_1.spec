Method Signature:
method PairwiseAddition(seq: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of result should be one less than the length of seq (if seq has at least two elements)
    - Each element in result should be the sum of two neighboring elements in seq
    - For each index i in 0 .. |result| - 1, result[i] == seq[i] + seq[i + 1]