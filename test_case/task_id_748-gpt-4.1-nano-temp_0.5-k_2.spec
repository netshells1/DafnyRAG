Method Signature:
method InsertSpacesBeforeCapitals(s: string) returns (v: string)

Postconditions_prompt:
- The returned string contains all characters of the input string in order
- For each position in the input string where a capital letter (A-Z) is immediately preceded by a lowercase letter (a-z), a space is inserted before the capital letter in the output string
- No other characters are changed or removed in the output string