Method Signature:
method MaxLengthLists(lists: seq<seq<int>>) returns (maxLists: seq<seq<int>>)

Postconditions_prompt:
- The returned sequence contains all sublists from the input that have the maximum length
- Every sublist in the returned sequence has length equal to the maximum length among all sublists in the input
- No sublist outside the returned sequence has a length equal to the maximum length