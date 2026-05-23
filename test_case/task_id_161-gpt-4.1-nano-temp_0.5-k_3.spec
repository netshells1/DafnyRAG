Method Signature:
method RemoveElements(source: array<int>, toRemove: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array should contain only elements from the source array that are not present in the toRemove array
- All elements in the result array should be from the source array
- The result array should not contain any elements present in the toRemove array
- The order of elements in the result array should be the same as their order in the source array