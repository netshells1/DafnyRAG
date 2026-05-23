Method Signature:
method ArrayToSequence(a: array<int>) returns (seqResult: seq<int>)

Postconditions_prompt:
- The returned sequence seqResult contains all elements of the input array in order
- The length of seqResult equals the length of the input array
- For all indices i within the bounds of the array, seqResult[i] == a[i]