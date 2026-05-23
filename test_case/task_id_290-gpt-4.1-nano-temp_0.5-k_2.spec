Method Signature:
method FindLongestLists(lists: seq<seq<T>>) returns (longestLists: seq<seq<T>>)

Postconditions_prompt:
- The returned sequence contains all sublists from the input lists that have the maximum length
- Every sublist in the result has a length equal to the maximum length among all sublists in the input
- All sublists in the result are elements of the input list of lists