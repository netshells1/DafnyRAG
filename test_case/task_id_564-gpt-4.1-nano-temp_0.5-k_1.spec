Method Signature:
method CountUnequalPairs(nums: seq<int>) returns (count: nat)

Postconditions_prompt:
- The count equals the number of unordered pairs (i, j) with 0 ≤ i < j < |nums| such that nums[i] ≠ nums[j]
    - All such pairs are counted exactly once
    - The count is a non-negative integer