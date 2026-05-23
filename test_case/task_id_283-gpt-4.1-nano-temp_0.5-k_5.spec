Method Signature:
method CheckDigitFrequencies(n: int) returns (result: bool)

Postconditions_prompt:
- If the result is true, then for every digit d from 0 to 9, the frequency of d in n is less than or equal to d
- If the result is false, there exists at least one digit d such that the frequency of d in n is greater than d