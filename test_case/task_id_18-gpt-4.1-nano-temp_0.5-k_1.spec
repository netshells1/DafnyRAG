Method Signature:
method RemoveChars(s1: string, s2: string) returns (result: string)

Postconditions_prompt:
- The resulting string contains only characters from s1 that are not present in s2
- All characters in the result are from the original s1
- The order of characters in s1 is preserved for those not removed
- No characters from s2 are present in the resulting string