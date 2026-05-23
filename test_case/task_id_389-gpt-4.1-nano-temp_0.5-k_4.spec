Method Signature:
method Lucas(n: nat) returns (l: nat)

Postconditions_prompt:
- The returned value l is the nth Lucas number
    - For n = 0, l = 2
    - For n = 1, l = 1
    - For n > 1, l = Lucas(n - 1) + Lucas(n - 2)