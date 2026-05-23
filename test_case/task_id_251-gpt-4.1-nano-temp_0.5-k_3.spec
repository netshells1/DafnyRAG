Method Signature:
method InsertBeforeEach(lst: seq<string>, s: string) returns (result: seq<string>)

Postconditions_prompt:
- The resulting list contains twice as many elements as the input list
- For every position i in the original list, the element at position 2*i in the result is the string s
- The element immediately following each inserted s in the result is the corresponding original element from lst
- The order of the original elements is preserved in the result, with s inserted before each of them