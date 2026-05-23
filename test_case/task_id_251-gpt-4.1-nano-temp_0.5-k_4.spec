Method Signature:
method InsertBeforeEach(lst: seq<string>, s: string) returns (result: seq<string>)

Postconditions_prompt:
- The resulting sequence should contain twice as many elements as the input sequence
- For every original element at position i in the input list, the element at position 2*i in the result should be s
- The element immediately following each inserted s in the result should be the original element from the input list at position i
- The order of the original elements should be preserved in the resulting sequence after the inserted strings