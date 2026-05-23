Method Signature:
method GetNegatives(arr: array<int>) returns (negatives: seq<int>)

Postconditions_prompt:
- The returned sequence contains only the negative numbers from the input array
- All elements in the sequence are elements of the input array
- The sequence contains only elements less than zero
- The sequence preserves the order of the negative elements as they appear in the input array