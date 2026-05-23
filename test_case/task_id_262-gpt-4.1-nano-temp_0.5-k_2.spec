Method Signature:
method SplitArrayAtL(a: array<int>, L: int) returns (result: seq<int>)

Postconditions_prompt:
- The resulting sequence contains all elements of the input array in order
- The length of the sequence is equal to the length of the input array
- The first L elements of the sequence correspond to the first L elements of the input array
- The remaining elements of the sequence correspond to the elements of the input array starting from index L onwards