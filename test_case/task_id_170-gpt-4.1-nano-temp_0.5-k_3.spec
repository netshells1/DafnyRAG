Method Signature:
method RangeSum(a: array<int>, startIndex: int, endIndex: int) returns (sum: int)

Postconditions_prompt:
- The sum is equal to the sum of elements in the array from startIndex to endIndex inclusive
    - startIndex and endIndex are within the valid bounds of the array indices
    - The sum only includes elements whose indices are between startIndex and endIndex, inclusive