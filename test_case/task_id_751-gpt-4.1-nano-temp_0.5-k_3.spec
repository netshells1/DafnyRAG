Method Signature:
method IsMinHeap(a: array<int>) returns (isHeap: bool)

Postconditions_prompt:
- If the method returns true, then the array satisfies the min-heap property where each parent is less than or equal to its children
- If the method returns false, then there exists at least one parent node in the array that is greater than its child(ren) and the array does not represent a min heap