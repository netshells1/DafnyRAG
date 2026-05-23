Method Signature:
method InsertBeforeEach(lst: seq<string>, s: string) returns (res: seq<string>)

Postconditions_prompt:
- The length of the resulting sequence is twice the length of the input sequence
- For each index i in the input sequence, the element at position 2*i in the output sequence is s
- For each index i in the input sequence, the element at position 2*i + 1 in the output sequence is the original element lst[i]
- The original input sequence remains unchanged