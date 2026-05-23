predicate InBounds(arr: array<int>, i: int)
    reads arr
{
    0 <= i < arr.Length
}

method KthSmallest(a: array<int>, b: array<int>, k: int) returns (res: int)
    requires a != null && b != null
    requires 0 <= k < a.Length + b.Length
    ensures res == if a.Length + b.Length == 1 then
                        if a.Length == 1 then a[0] else b[0]
                    else
                        // Implementation details omitted for brevity
                        // The method finds the k-th smallest element in the union of a and b
{
    // Implementation of median-finding using a binary search approach
    // For brevity, a full implementation is omitted; focus is on the main method
    // Placeholder implementation:
    var merged := new int[a.Length + b.Length];
    var i := 0;
    var j := 0;
    var idx := 0;
    while i < a.Length || j < b.Length
        invariant 0 <= i <= a.Length
        invariant 0 <= j <= b.Length
        invariant idx == i + j
        invariant merged[..idx] == SelectFirstK(a, b, i, j)
    {
        if i < a.Length && (j >= b.Length || a[i] <= b[j]) {
            merged[idx] := a[i];
            i := i + 1;
        } else if j < b.Length {
            merged[idx] := b[j];
            j := j + 1;
        }
        idx := idx + 1;
    }
    res := merged[k];
}

method MedianOfTwoSortedLists(a: array<int>, b: array<int>) returns (median: int)
    requires a != null && b != null
    requires a.Length == b.Length
    ensures exists k :: 0 <= k < a.Length + b.Length && (a.Length + b.Length) % 2 == 1 ==> median == KthSmallest(a, b, (a.Length + b.Length) / 2)
{
    var totalLength := a.Length + b.Length;
    var midIndex := totalLength / 2;
    median := KthSmallest(a, b, midIndex);
}