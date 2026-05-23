Method Signature:
method PowerEachElementInList(lst: seq<int>, n: int) returns (result: seq<int>)

Postconditions_prompt:
- The result list should have the same length as the input list
    - For each index i in 0 .. |lst| - 1, result[i] should be lst[i] raised to the power n