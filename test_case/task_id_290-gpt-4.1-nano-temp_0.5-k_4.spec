Method Signature:
method MaxLengthLists(lists: seq<seq<T>>) returns (maxLists: seq<seq<T>>)

Postconditions_prompt:
- The returned sequence contains only the subsequences from the input that have the maximum length among all input subsequences
- Every sequence in the returned sequence has length equal to the maximum length found in the input list of lists