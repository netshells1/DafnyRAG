Method Signature:
method ExtractStrings(seq: seq<string>, size: int) returns (result: seq<string>)

Postconditions_prompt:
- The length of the resulting sequence is equal to the specified size
- The resulting sequence is a prefix of the input sequence
- The sequence contains the first 'size' elements of the input sequence, if available
- If the input sequence has fewer than 'size' elements, the result contains all elements of the input sequence