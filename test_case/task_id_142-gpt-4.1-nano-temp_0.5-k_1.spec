Method Signature:
method CountMatchingPositions(list1: seq<int>, list2: seq<int>, list3: seq<int>) returns (count: nat)

Postconditions_prompt:
- The returned count is equal to the number of positions i where list1[i], list2[i], and list3[i] are all equal
- The count is zero if no such positions exist
- The count does not exceed the length of the shortest list among the three input lists