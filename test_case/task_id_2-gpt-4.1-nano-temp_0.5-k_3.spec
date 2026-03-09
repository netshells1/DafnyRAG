Method Signature:
method SharedElements(a: array<int>, b: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array contains only elements that are present in both input arrays
- Every element in the result array is an element of at least one of the input arrays
- All elements in the result array are common to both arrays
- The result array does not contain duplicate elements
- The order of elements in the result array does not matter