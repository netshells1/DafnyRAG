Method Signature:
method FindMinLengthSublist(lst: seq<int>) returns (sublist: seq<int>)

Postconditions_prompt:
- The returned sublist is a contiguous subsequence of the input list
- The length of the returned sublist is minimal among all such contiguous subsequences of the input list
- The returned sublist is not empty (if the input list is not empty)