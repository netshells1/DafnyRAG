Method Signature:
method SmallestListLength(lists: seq<seq<int>>) returns (length: int)

Postconditions_prompt:
- The returned value is the length of the shortest list within the input list of lists
    - If the input list of lists is empty, the returned length is 0
    - The returned length is less than or equal to the length of every list in the input sequence