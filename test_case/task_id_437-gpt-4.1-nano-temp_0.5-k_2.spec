Method Signature:
method RemoveOddCharacters(s: string) returns (result: string)

Postconditions_prompt:
- The resulting string contains only characters from the original string at even indices
- The length of the resulting string is equal to the number of even indices in the original string
- For each index i in the resulting string, the character corresponds to the character at the even index i*2 in the original string