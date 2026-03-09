Method Signature:
method FindLongWords(s: string) returns (longWords: seq<string>)

Postconditions_prompt:
- The returned sequence contains all words from the input string that have a length of at least 4 characters
    - Each word in the sequence is a substring of the input string, separated by whitespace or punctuation
    - All words in the sequence meet the minimum length requirement of 4 characters