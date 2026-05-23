Method Signature:
method ReplaceSpacesWithPercent20(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string is at least as long as the input string
- All space characters in the input string are replaced with the string "%20" in the output
- All other characters are unchanged and appear in the same relative order as in the input string