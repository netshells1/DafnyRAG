Method Signature:
method CountXorEvenPairs(a: array<int>) returns (count: nat)

Postconditions_prompt:
- The count is equal to the number of distinct pairs (i, j) with i < j such that a[i] xor a[j] is even
- The count is non-negative and correctly reflects the total number of such pairs in the input array