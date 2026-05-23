Method Signature:
method CountSequences(m: int, n: int) returns (count: int)

Postconditions_prompt:
- The returned count is the number of sequences of length n
    - Each sequence element is a positive integer
    - For each consecutive pair of elements in the sequence, the latter is greater than or equal to twice the previous element
    - Each element in the sequence is less than or equal to m