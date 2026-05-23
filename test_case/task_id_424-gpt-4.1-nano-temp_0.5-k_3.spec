Method Signature:
method ExtractRearCharacters(strings: seq<string>) returns (rearChars: seq<char>)

Postconditions_prompt:
- The length of the returned sequence equals the length of the input sequence
- For each index i in 0 .. |strings| - 1, if strings[i] is non-empty, then rearChars[i] is the last character of strings[i]
- For each index i in 0 .. |strings| - 1, if strings[i] is empty, then rearChars[i] is the default value of char (e.g., '\0')