Method Signature:
method IsMinHeap(a: array<int>) returns (result: bool)

Postconditions_prompt:
- If the method returns true, then the array satisfies the min-heap property (each parent is less than or equal to its children)
- If the method returns false, then there exists at least one parent node that is greater than its child(ren) in the array representation of the heap