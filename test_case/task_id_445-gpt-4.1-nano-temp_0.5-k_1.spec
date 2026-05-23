Method Signature:
method SequenceWiseMultiplication(seq1: seq<int>, seq2: seq<int>) returns (result: seq<int>)

Postconditions_prompt:
- The length of the result sequence should be equal to the length of the input sequences
    - For each index i within the bounds of the sequences, result[i] should be equal to seq1[i] * seq2[i]