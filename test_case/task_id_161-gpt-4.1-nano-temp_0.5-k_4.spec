Method Signature:
method RemoveElements(a: array<int>, b: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The result array contains only elements from the input array 'a' that are not present in array 'b'
- The result array does not contain any elements that are present in 'b'
- The order of elements in the result array should be the same as their order in 'a' for those elements retained