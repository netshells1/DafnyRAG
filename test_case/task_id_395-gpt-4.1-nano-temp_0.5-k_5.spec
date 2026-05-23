Method Signature:
method FindFirstNonRepeatedChar(s: string) returns (found: bool, c: char)

Postconditions_prompt:
- If found is true, then c is the first character in the input string that does not repeat elsewhere
- If found is false, then every character in the input string is repeated at least once, and c is undefined or arbitrary