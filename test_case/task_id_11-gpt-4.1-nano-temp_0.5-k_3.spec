Method Signature:
method RemoveFirstAndLastOccurrence(s: string, c: char) returns (result: string)

Postconditions_prompt:
- The resulting string does not contain the first occurrence of c in the original string
- The resulting string does not contain the last occurrence of c in the original string
- All other characters in the string remain unchanged and in the same order
- The length of the resulting string is equal to the original length minus two if c appears at least twice; otherwise, it is equal to the original length if c does not appear or appears only once