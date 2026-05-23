Method Signature:
method IsMonotonic(a: array<int>) returns (result: bool)

Postconditions_prompt:
- If the method returns true, the array is either entirely non-decreasing or non-increasing
- If the method returns false, the array is not monotonic (neither entirely non-decreasing nor non-increasing)