Method Signature:
method CountMatchingPositions(list1: seq<int>, list2: seq<int>, list3: seq<int>) returns (count: nat)

Postconditions_prompt:
- The returned count equals the number of positions i where list1[i], list2[i], and list3[i] are all equal
- The count is zero if there are no positions with identical items across all three lists
- The count equals the total number of positions where the items at the same index are identical in all three lists