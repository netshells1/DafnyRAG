Method Signature:
method AddTupleToList(t: (int, int), lst: seq<(int, int)>) returns (new_lst: seq<(int, int)>)

Postconditions_prompt:
- The resulting sequence contains all elements of the original sequence followed by the input tuple
    - The length of the resulting sequence is one more than the length of the original sequence