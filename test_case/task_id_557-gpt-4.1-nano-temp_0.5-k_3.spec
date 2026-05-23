Method Signature:
method ToggleCase(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string must be the same as the length of the input string
- For each character in the input string, the corresponding character in the output string is the case-toggled version if it is an alphabetic character (uppercase becomes lowercase, lowercase becomes uppercase)
- All non-alphabetic characters remain unchanged in the output string