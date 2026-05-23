Method Signature:
method CountSequences(m: int, n: int) returns (count: int)

Postconditions_prompt:
- The returned count is the number of sequences of length n
    - Each sequence element is a positive integer
    - For each sequence, every element is greater than or equal to twice the previous element
    - For each sequence, every element is less than or equal to m