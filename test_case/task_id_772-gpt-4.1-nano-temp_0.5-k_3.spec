Method Signature:
method RemoveWordsOfLengthK(s: string, k: int) returns (result: string)

Postconditions_prompt:
- The resulting string contains only words from the input string that do not have length k
    - All words of length k are removed from the input string
    - The order of the remaining words is preserved
    - The resulting string may have leading, trailing, or multiple spaces removed or normalized as appropriate