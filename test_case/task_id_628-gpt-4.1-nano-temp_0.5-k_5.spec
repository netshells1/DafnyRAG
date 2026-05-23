Method Signature:
method ReplaceSpacesWithPercent20(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string may be greater than or equal to the length of the input string
- All space characters in the input string are replaced with the sequence "%20" in the output string
- All other characters are unchanged
- The order of characters in the output string corresponds to the input string with spaces replaced appropriately