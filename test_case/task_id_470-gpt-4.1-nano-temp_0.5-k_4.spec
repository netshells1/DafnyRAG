Method Signature:
method PairwiseAddNeighbors(seq: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence is either equal to the length of the input sequence (if the input has only one element) or one less (if the input has at least two elements)
    - For each index i in 0 .. |result|-1, result[i] == seq[i] + seq[i+1]
    - If the input sequence is empty, the result is also empty