Method Signature:
method InsertSpacesBeforeCapitals(s: string) returns (v: string)

Postconditions_prompt:
- The returned string contains all characters of the input string in order
- A space is inserted before each uppercase letter in the input string, except if it is the first character
- The sequence of non-uppercase characters remains unchanged and in the same order
- The length of the returned string is greater than or equal to the length of the input string, accounting for inserted spaces