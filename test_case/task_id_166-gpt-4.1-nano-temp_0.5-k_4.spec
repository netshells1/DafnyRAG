Method Signature:
method CountXorEvenPairs(a: array<int>) returns (count: nat)

Postconditions_prompt:
- The output count equals the number of distinct pairs (i, j) with i < j such that a[i] xor a[j] is even
- All such pairs are counted exactly once
- The count reflects the total number of pairs satisfying the condition within the input array