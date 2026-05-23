Method Signature:
method FindPerfectSquaresBetween(low: int, high: int) returns (result: seq<int>)

Postconditions_prompt:
- The result sequence contains all perfect squares greater than or equal to low and less than or equal to high
    - Every element in the result sequence is a perfect square
    - All perfect squares between low and high are included in the result sequence
    - The sequence is sorted in non-decreasing order