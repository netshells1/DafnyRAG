Method Signature:
method ListDifference(l1: seq<int>, l2: seq<int>) returns (diff: seq<int>)

Postconditions_prompt:
- The result sequence contains elements that are in l1 but not in l2, and elements that are in l2 but not in l1
- The result sequence includes all such elements, with no duplicates
- The order of elements in the result sequence does not matter