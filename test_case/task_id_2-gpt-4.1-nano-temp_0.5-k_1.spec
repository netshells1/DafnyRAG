Method Signature:
method SharedElements(a: array<int>, b: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array contains all elements that are present in both input arrays
- The result array includes only elements that appear in both arrays at least once
- The result array does not contain duplicate elements
- The order of elements in the result array does not matter