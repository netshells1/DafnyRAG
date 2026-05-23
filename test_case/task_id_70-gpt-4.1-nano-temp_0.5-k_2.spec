Method Signature:
method AllSequencesHaveEqualLength(sequences: seq<seq<T>>) returns (result: bool)

Postconditions_prompt:
- If the result is true, then all sequences in the list have the same length
- If the result is false, then there exists at least one pair of sequences with different lengths