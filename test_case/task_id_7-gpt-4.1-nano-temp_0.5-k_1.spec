Method Signature:
method FindLongWords(s: string) returns (words: seq<string>)

Postconditions_prompt:
- The output sequence 'words' contains all substrings of 's' that are words with length at least 4 characters
- Each element in 'words' is a contiguous sequence of characters from 's' that forms a valid word of length ≥ 4
- All such qualifying words from 's' are included in 'words', and no other substrings are present