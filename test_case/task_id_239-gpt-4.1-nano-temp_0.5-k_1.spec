Method Signature:
method CountSequences(m: int, n: int) returns (count: int)

Postconditions_prompt:
- The returned count should represent the number of sequences of length n
    - Each sequence element is a positive integer
    - For each consecutive pair in the sequence, the subsequent element is greater than or equal to twice the previous element and less than or equal to m