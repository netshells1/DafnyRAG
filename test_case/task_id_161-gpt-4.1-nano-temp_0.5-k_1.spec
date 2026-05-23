Method Signature:
method RemoveElements(source: array<int>, toRemove: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array contains only elements from the source array that are not present in the toRemove array
    - The result array does not contain any elements that are present in the toRemove array
    - All elements in the result array are from the source array, preserving the order of their first occurrence in source