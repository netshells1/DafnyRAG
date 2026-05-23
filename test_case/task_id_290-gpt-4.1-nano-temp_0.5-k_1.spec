Method Signature:
method MaxLengthLists(lists: seq<seq<int>>) returns (maxLists: seq<seq<int>>)

Postconditions_prompt:
- The returned sequence contains all sublists from the input that have the maximum length among all sublists
- Every list in the returned sequence has length equal to the maximum length found in the input lists