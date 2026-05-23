Method Signature:
method ListDifference(list1: seq<int>, list2: seq<int>) returns (diff: seq<int>)

Postconditions_prompt:
- The result sequence contains elements from list1 that are not in list2
- The result sequence contains elements from list2 that are not in list1
- The result sequence is the concatenation of these two sets of elements
- The order of elements in the result sequence preserves the order from the original lists for each respective set