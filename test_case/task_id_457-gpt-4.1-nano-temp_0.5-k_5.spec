Method Signature:
method FindShortestSublist(lst: seq<int>) returns (sublist: seq<int>)

Postconditions_prompt:
- The returned sublist is a contiguous subsequence of the input list
- Among all such subsequences, the returned sublist has the minimal possible length
- The returned sublist is a sublist of the input list (i.e., exists as a contiguous segment within the input)