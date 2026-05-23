Method Signature:
method ExtractStrings(seq: seq<string>, size: nat) returns (extracted: seq<string>)

Postconditions_prompt:
- The length of the returned sequence is equal to size
- All elements in the returned sequence are consecutive elements from the input sequence
- The returned sequence is a subsequence of the input sequence
- The extracted strings are exactly those starting from some position in the input sequence, maintaining their original order