Method Signature:
method ReplaceSpacesWithPercent20(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string is at least as long as the input string
- Every space character in the input string is replaced with the sequence "%20" in the output string
- All other characters are unchanged and appear in the same order as in the input string