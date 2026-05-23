Method Signature:
method GetFirstElementsOfSublists(lists: seq<seq<int>>) returns (firsts: seq<int>)

Postconditions_prompt:
- The length of the returned sequence should be equal to the number of sublists in the input
- For each index i, if lists[i] is non-empty, then firsts[i] equals the first element of lists[i]
- For each index i, if lists[i] is empty, then firsts[i] is 0 (or some default value) or the method handles empty sublists appropriately
- The input sequence of sequences remains unchanged