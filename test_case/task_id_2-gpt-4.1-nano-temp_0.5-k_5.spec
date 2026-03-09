Method Signature:
method SharedElements(a: array<int>, b: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array contains only elements that are present in both input arrays
- All elements in the result array are from the input arrays
- The result array contains no duplicate elements
- Every element in the result array exists in both input arrays