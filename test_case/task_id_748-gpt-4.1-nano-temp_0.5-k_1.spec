Method Signature:
method InsertSpacesBeforeCapitals(s: string) returns (v: string)

Postconditions_prompt:
- The length of the returning string may be greater than or equal to the length of the input string
- For every position in the output string, the characters correspond to the input string's characters, with spaces inserted before capital letters in the input string (except if the capital letter is at the beginning)
- The order of characters in the output string preserves the order of characters from the input string, with spaces added appropriately before capital letters
- No other characters are changed or removed