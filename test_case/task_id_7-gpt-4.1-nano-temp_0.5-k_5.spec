Method Signature:
method FindLongWords(s: string) returns (words: seq<string>)

Postconditions_prompt:
- The returned sequence contains all words from the input string that are at least 4 characters long
- Every word in the returned sequence has length greater than or equal to 4
- All words in the returned sequence are substrings of the input string separated by whitespace or punctuation (depending on tokenization rules)