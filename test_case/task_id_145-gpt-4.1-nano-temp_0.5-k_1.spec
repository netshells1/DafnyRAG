Method Signature:
method MaxDifference(a: array<int>) returns (diff: int)

Postconditions_prompt:
- The returned value is the maximum difference between any two elements in the input array
    - There exist indices i, j such that diff = a[i] - a[j]
    - For all pairs of indices k, l in the array, diff ≥ a[k] - a[l]