Method Signature:
method IsIntegerString(s: string) returns (result: bool)

Postconditions_prompt:
- The result is true if and only if the string s represents a valid integer
- If the result is true, then s matches the pattern of an optional sign followed by digits
- If the result is false, then s does not match the pattern of a valid integer representation