Method Signature:
method RemoveElementsFromArray(source: array<int>, toRemove: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array contains only elements from the source array that are not present in the toRemove array
    - All elements in the result array are from the source array
    - No elements in the result array are present in the toRemove array
    - The order of elements in the result array corresponds to their order in the source array, excluding removed elements