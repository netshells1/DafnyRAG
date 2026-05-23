Method Signature:
method ListDifference(list1: seq<int>, list2: seq<int>) returns (difference: seq<int>)

Postconditions_prompt:
- The returned sequence contains elements that are in list1 but not in list2
- The returned sequence contains elements that are in list2 but not in list1
- The difference sequence includes only elements that are unique to each list (symmetric difference)
- The order of elements in the result reflects their order in the original lists for each respective set of elements