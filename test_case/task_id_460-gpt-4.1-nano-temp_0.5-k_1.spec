Method Signature:
method FirstElementsOfSublists(lists: seq<seq<int>>) returns (firsts: seq<int>)

Postconditions_prompt:
- The length of the output sequence equals the number of sublists in the input
- For each index i in the output sequence, the element equals the first element of the i-th sublist in the input
- If any sublist is empty, the corresponding element in the output sequence can be any value (or specify behavior accordingly)