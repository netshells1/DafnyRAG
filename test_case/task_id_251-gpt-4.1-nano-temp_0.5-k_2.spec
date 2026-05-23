Method Signature:
method InsertBeforeEach(lst: seq<string>, s: string) returns (result: seq<string>)

Postconditions_prompt:
- The resulting sequence contains twice as many elements as the input list
- For each original element in the input list, the corresponding element in the result sequence is the string s followed by the original element
- The order of the original elements is preserved, with s inserted immediately before each of them