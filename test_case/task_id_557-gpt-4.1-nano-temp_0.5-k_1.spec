Method Signature:
method ToggleCase(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string must be the same as the length of the input string
- For each character in the input string:
    - If it is an uppercase letter, it is lowercase in the output string
    - If it is a lowercase letter, it is uppercase in the output string
    - All other characters remain unchanged in the output string