Method Signature:
method CountUnequalPairs(lst: seq<int>) returns (count: nat)

Postconditions_prompt:
- The count represents the total number of unordered pairs (i, j) with i < j in the list such that lst[i] != lst[j]
    - All pairs are counted exactly once (unordered pairs)
    - The count is non-negative and does not exceed the total number of pairs possible in the list