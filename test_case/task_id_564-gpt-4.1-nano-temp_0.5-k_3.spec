Method Signature:
method CountUnequalPairs(lst: seq<int>) returns (count: nat)

Postconditions_prompt:
- The result count equals the number of unordered pairs (i, j) with i < j where lst[i] != lst[j]
    - All pairs are considered without duplication
    - The count accurately reflects the total number of such pairs in the input sequence