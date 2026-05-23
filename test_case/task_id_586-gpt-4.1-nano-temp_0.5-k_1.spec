Method Signature:
method SplitAndAppend(l: seq<int>, n: int) returns (r: seq<int>)

Postconditions_prompt:
- The length of the returning sequence must be equal to the length of the input sequence
- The sequence r contains all elements of l, with the first n elements moved to the end in their original order
- The relative order of elements in the original sequence is preserved, just rotated at position n