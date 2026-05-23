Method Signature:
method GetTwoWordsStartingWithP(words: seq<string>) returns (word1: string, word2: string)

Postconditions_prompt:
- Both word1 and word2 are elements of the input list 'words'
- Both word1 and word2 start with the letter 'p' or 'P'
- word1 and word2 are distinct words (if at least two such words exist in the list)