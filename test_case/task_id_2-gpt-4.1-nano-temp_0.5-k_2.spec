Method Signature:
method SharedElements(a: array<int>, b: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array contains all elements that are present in both input arrays
- Each element in the result array is a common element from the input arrays
- The result array contains no duplicate elements
- The order of elements in the result array does not matter