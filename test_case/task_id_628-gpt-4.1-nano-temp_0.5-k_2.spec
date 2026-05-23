Method Signature:
method ReplaceSpacesWithPercent20(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string is equal to the length of the input string plus the number of spaces in the input string multiplied by 2
- All spaces in the input string are replaced with the sequence "%20" in the output string
- All other characters are unchanged and appear in the same order as in the input string