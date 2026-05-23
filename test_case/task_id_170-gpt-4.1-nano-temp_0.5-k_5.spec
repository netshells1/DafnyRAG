Method Signature:
method RangeSum(a: array<int>, startIndex: int, endIndex: int) returns (sum: int)

Postconditions_prompt:
- The sum is equal to the total of elements in the array from startIndex to endIndex inclusive
- startIndex and endIndex are within the bounds of the array indices
- If startIndex > endIndex, the sum is zero (assuming the method handles such cases accordingly)