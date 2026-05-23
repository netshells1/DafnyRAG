Method Signature:
method RemoveKLengthWords(s: string, k: int) returns (v: string)

Postconditions_prompt:
- The length of the returning string may be less than or equal to the length of the input string
- All words in the input string with length exactly k are removed in the output string
- All other words and characters are preserved in their original order, excluding the removed words