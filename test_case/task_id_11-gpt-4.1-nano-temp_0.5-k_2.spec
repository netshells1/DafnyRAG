Method Signature:
method RemoveFirstAndLastOccurrence(s: string, c: char) returns (result: string)

Postconditions_prompt:
- The resulting string does not contain the first occurrence of c
- The resulting string does not contain the last occurrence of c
- All other characters in the string remain unchanged
- The length of the resulting string is equal to the original length minus two, unless c does not occur twice, in which case the length remains unchanged