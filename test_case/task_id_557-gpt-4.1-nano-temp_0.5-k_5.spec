Method Signature:
method ToggleCase(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string must be the same as the length of the input string
- For each position i in the input string:
    - If s[i] is an uppercase letter, v[i] is the corresponding lowercase letter
    - If s[i] is a lowercase letter, v[i] is the corresponding uppercase letter
    - Otherwise, v[i] is the same as s[i]