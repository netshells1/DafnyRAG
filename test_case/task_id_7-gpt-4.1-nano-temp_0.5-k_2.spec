Method Signature:
method FindLongWords(s: string) returns (words: seq<string>)

Postconditions_prompt:
- The returned sequence contains all words from the input string that have a length of at least 4 characters
- Each element in the sequence is a word from the input string with length greater than or equal to 4
- All words in the sequence are extracted in the order they appear in the input string