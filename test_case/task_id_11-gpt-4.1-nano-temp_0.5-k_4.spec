Method Signature:
method RemoveFirstAndLastOccurrence(s: string, c: char) returns (result: string)

Postconditions_prompt:
- The result string does not contain the first occurrence of c in s
- The result string does not contain the last occurrence of c in s
- All other characters in the string remain unchanged
- The length of the result string is equal to the length of s minus two (if c occurs at least twice), or unchanged if c occurs less than twice