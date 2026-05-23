Method Signature:
method ReplaceLastElementWithList(l1: seq<int>, l2: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The resulting list should contain all elements of the original first list except the last element
    - The last element of the resulting list should be replaced by all elements of the second list
    - The length of the resulting list should be equal to the length of the original first list minus one plus the length of the second list