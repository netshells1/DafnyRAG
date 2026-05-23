Method Signature:
method ClosestSmallerThanN(a: array<int>, n: int) returns (result: int)

Postconditions_prompt:
- The returned value is the largest number in the input array that is strictly less than n
    - If no such number exists, result is assigned a default value (e.g., 0 or a specified sentinel) and the method's behavior should specify this case accordingly