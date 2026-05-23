Method Signature:
method ListDifference(list1: seq<int>, list2: seq<int>) returns (diff: seq<int>)

Postconditions_prompt:
- The result sequence contains elements that are in list1 but not in list2
- The result sequence contains elements that are in list2 but not in list1
- The result sequence is the concatenation of these two difference sequences
- The order of elements in the result sequence corresponds to their order in the respective input lists