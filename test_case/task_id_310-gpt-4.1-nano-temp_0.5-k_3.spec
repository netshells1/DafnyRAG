Method Signature:
method StringToCharArray(s: string) returns (arr: array<char>)

Postconditions_prompt:
- The resulting array has length equal to the length of the input string
- For each index i in 0 .. s.Length - 1, arr[i] == s[i]
- The array contains exactly the characters of the input string in order