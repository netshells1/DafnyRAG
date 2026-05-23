Method Signature:
method CountMatchingPositions(list1: seq<int>, list2: seq<int>, list3: seq<int>) returns (count: nat)

Postconditions_prompt:
- The value of count equals the number of positions i where list1[i], list2[i], and list3[i] are all equal
- For all positions i, if list1[i], list2[i], and list3[i] are equal, then count increases by 1
- For all positions i, if list1[i], list2[i], and list3[i] are not all equal, then count does not increase at position i