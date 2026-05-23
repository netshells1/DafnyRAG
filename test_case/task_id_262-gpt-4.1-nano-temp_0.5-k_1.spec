Method Signature:
method SplitArrayAtL(a: array<int>, L: nat) returns (result: seq<int>)

Postconditions_prompt:
- The length of the resulting sequence should be equal to the length of the input array
- The first L elements of the sequence should correspond to the first L elements of the array
- The remaining elements of the sequence should correspond to the elements of the array starting from position L
- The sequence should contain all elements of the array in their original order, partitioned at position L