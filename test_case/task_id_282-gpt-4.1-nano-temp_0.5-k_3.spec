Method Signature:
method ElementWiseSubtract(a: array<int>, b: array<int>) returns (result: array<int>)

Postconditions_prompt:
- The length of the result array should be equal to the length of the input arrays
    - Each element in the result array should be the difference between the corresponding elements of the input arrays (a[i] - b[i]) for all valid indices i
    - The result array contains the results of element-wise subtraction for all indices in the input arrays