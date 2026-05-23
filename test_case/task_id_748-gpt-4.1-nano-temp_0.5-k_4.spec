Method Signature:
method InsertSpacesBeforeCapitals(s: string) returns (v: string)

Postconditions_prompt:
- The output string contains all characters of the input string, with additional spaces inserted before each uppercase letter that is not at the beginning of the string
    - No other characters are changed or removed
    - The relative order of characters in the original string is preserved, aside from inserted spaces