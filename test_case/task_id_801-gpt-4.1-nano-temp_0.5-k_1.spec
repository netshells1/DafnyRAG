Method Signature:
method CountEqualNumbers(x: int, y: int, z: int) returns (count: nat)

Postconditions_prompt:
- The value of count is equal to the number of input integers that are equal to each other (i.e., 1, 2, or 3)
    - If count is 3, then x, y, and z are all equal
    - If count is 2, then exactly two of the integers are equal and the third is different
    - If count is 1, then all three integers are distinct