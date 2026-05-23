Method Signature:
method MoveNumbersToEnd(s: string) returns (result: string)

Postconditions_prompt:
- The length of the output string is the same as the input string
- All numeric characters in the input string are positioned at the end of the output string
- The relative order of non-numeric characters in the input string is preserved at the beginning of the output string
- The relative order of numeric characters in the input string is preserved at the end of the output string