Method Signature:
method ToggleCase(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string must be the same as the length of the input string
- For each character in the input string:
    - If the character is uppercase, it is lowercase in the output
    - If the character is lowercase, it is uppercase in the output
    - All other characters remain unchanged