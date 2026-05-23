Method Signature:
method ReverseEachString(lst: seq<string>) returns (result: seq<string>)

Postconditions_prompt:
- The result sequence has the same length as the input sequence
- For each index i in the sequence, result[i] is the reverse of lst[i]
- The order of the sequence elements is preserved