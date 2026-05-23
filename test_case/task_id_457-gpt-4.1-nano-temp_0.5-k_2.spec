Method Signature:
method FindMinLengthSublist(lst: seq<int>) returns (sublist: seq<int>)

Postconditions_prompt:
- The returned sublist is a contiguous subsequence of the input list
    - The length of the returned sublist is minimal among all such contiguous subsequences
    - The returned sublist is a non-empty subsequence of the input list (if the input list is non-empty)