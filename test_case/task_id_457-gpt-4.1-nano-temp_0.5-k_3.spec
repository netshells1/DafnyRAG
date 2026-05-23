Method Signature:
method FindMinLengthSublist(lst: seq<int>) returns (sublist: seq<int>)

Postconditions_prompt:
- The returned sublist is a contiguous subsequence of the input list
    - The length of the returned sublist is less than or equal to the length of any other sublist of the input list
    - The returned sublist is non-empty if the input list is non-empty