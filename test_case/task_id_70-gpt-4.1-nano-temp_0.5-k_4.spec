Method Signature:
method AllSequencesHaveEqualLength(sequences: seq<seq<T>>) returns (result: bool)

Postconditions_prompt:
- If the result is true, all sequences in the list have the same length
- If the result is false, there exist at least two sequences with different lengths