Method Signature:
method GetTwoWordsStartingWithP(words: seq<string>) returns (word1: string, word2: string)

Postconditions_prompt:
- Both word1 and word2 are elements of the input list
- Both word1 and word2 start with the letter 'p' or 'P'
- word1 and word2 are distinct words (if at least two such words exist in the list)
- If fewer than two words start with 'p', then the method may return empty strings or the precondition is not guaranteed to hold