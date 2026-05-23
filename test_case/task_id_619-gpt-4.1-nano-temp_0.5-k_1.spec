Method Signature:
method MoveNumbersToEnd(s: string) returns (result: string)

Postconditions_prompt:
- The length of the output string must be equal to the length of the input string
    - All numeric characters in the input string are positioned at the end of the output string
    - The relative order of non-numeric characters in the output string matches their order in the input string
    - The numeric characters in the output string appear in the same order as they did in the input string