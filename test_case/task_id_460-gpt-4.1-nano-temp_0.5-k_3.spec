Method Signature:
method GetFirstElements(lists: seq<seq<int>>) returns (firsts: seq<int>)

Postconditions_prompt:
- The length of the returned sequence equals the number of sublists in the input
- For each index i, if lists[i] is non-empty, then firsts[i] equals the first element of lists[i]
- If lists[i] is empty, then firsts[i] is 0 (or some default value) or the behavior is unspecified (depending on implementation constraints)