Method Signature:
method ExtractRearCharacters(strings: seq<string>) returns (result: seq<char>)

Postconditions_prompt:
- The length of the result sequence is equal to the length of the input sequence
- For each index i in 0..|strings|-1, if strings[i] is non-empty, then result[i] is the last character of strings[i]
- For each index i in 0..|strings|-1, if strings[i] is empty, then result[i] can be any character (or the method may specify a default character)