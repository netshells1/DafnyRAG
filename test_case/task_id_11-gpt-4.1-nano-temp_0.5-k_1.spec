Method Signature:
method RemoveFirstAndLastOccurrence(s: string, c: char) returns (result: string)

Postconditions_prompt:
- The resulting string does not contain any occurrence of c at the first or last position where c appears in the original string
- All other characters in the string remain unchanged and in their original order
- The length of the output string is less than or equal to the length of the input string, decreasing by exactly two if c appears at least twice; otherwise, it remains the same