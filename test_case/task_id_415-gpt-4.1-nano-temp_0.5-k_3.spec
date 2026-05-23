Method Signature:
method MaxProductPair(a: array<int>) returns (i: int, j: int)

Postconditions_prompt:
- The pair of indices (i, j) corresponds to elements in the array whose product is maximized
    - 0 <= i < a.Length and 0 <= j < a.Length and i != j
    - For all indices k, l in [0 .. a.Length - 1], if k != l, then a[k] * a[l] <= a[i] * a[j]