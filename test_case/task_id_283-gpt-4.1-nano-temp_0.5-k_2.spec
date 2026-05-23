Method Signature:
method CheckDigitFrequencies(n: int) returns (result: bool)

Postconditions_prompt:
- If the result is true, then for every digit d from 0 to 9, the number of times d appears in n is less than or equal to d
- If the result is false, then there exists at least one digit d for which the frequency of d in n is greater than d