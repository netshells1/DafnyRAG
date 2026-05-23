Method Signature:
method CountXorEvenPairs(a: array<int>) returns (count: nat)

Postconditions_prompt:
- The output count equals the number of distinct pairs (i, j) with i < j such that a[i] xor a[j] is even
    - All pairs where i < j and a[i] xor a[j] is even are included in the count
    - No pairs where a[i] xor a[j] is odd are counted