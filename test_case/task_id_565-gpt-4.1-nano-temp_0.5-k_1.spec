Method Signature:
method SplitIntoChars(s: string) returns (chars: seq<char>)

Postconditions_prompt:
- The sequence chars contains exactly the characters of the input string in order
- The length of chars is equal to the length of the input string
- For all indices i, 0 <= i < |s|, chars[i] == s[i]