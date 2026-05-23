Method Signature:
method LongestSublistLength(lists: seq<seq<int>>) returns (length: nat)

Postconditions_prompt:
- The returned length is the length of the longest sublist within the input sequence of sequences
    - The length is at least zero
    - For each sublist in the input, if its length equals the returned length, then it is among the longest sublists