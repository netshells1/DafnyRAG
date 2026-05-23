Method Signature:
method CountUnequalPairs(lst: seq<int>) returns (count: nat)

Postconditions_prompt:
- The result count equals the number of unordered pairs (i, j) with i < j such that lst[i] != lst[j]
- All pairs are counted only once (unordered)
- The count is non-negative and correctly represents the total number of such pairs in the list