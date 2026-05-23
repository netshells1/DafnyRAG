Method Signature:
method FindPerfectSquaresBetween(a: int, b: int) returns (squares: seq<int>)

Postconditions_prompt:
- All elements in the output sequence are perfect squares
- Each perfect square in the output sequence is greater than or equal to a and less than or equal to b
- The sequence contains no duplicate elements
- The sequence is sorted in non-decreasing order
- Every perfect square between a and b (inclusive) appears in the output sequence