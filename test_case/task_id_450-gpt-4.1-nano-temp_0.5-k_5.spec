Method Signature:
method ExtractStrings(s: seq<string>, size: nat) returns (result: seq<string>)

Postconditions_prompt:
- The result is a sequence containing the first 'size' elements of the input sequence 's'
- The length of the result sequence is equal to 'size'
- All elements in the result sequence are from the original sequence 's'
- If 'size' is greater than the length of 's', the result contains all elements of 's'