Method Signature:
method FindPerfectSquaresBetween(low: int, high: int) returns (squares: seq<int>)

Postconditions_prompt:
- The output sequence contains only integers that are perfect squares
- Every perfect square between low and high (inclusive) is included in the output sequence
- All elements in the output sequence are within the range [low, high]
- The sequence is sorted in non-decreasing order