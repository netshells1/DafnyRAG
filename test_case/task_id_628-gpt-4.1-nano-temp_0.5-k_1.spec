Method Signature:
method ReplaceSpacesWithPercent20(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string is equal to the length of the input string plus the number of spaces replaced multiplied by 2 (since '%20' replaces each space)
- All spaces in the input string are replaced with the sequence '%20' in the output string
- All other characters remain unchanged and are in the same order as in the input string