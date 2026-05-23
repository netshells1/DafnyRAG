method MedianOfTwoSortedLists(a: seq<int>, b: seq<int>) returns (median: int)
  requires a != null && b != null
  requires |a| == |b|
  requires Sorted(a)
  requires Sorted(b)
  ensures median == GetKthSmallest(a, b, (|a| + |b|) / 2)
{
    var totalLength := |a| + |b|;
    var k := totalLength / 2;
    median := GetKthSmallest(a, b, k);
}

// Helper function to find the k-th smallest element in the union of two sorted sequences
function method GetKthSmallest(a: seq<int>, b: seq<int>, k: int): int
  requires a != null && b != null
  requires 0 <= k < |a| + |b|
  requires Sorted(a)
  requires Sorted(b)
{
    if |a| == 0 then
        b[k]
    else if |b| == 0 then
        a[k]
    else
        var aMidIndex := |a| / 2;
        var bMidIndex := |b| / 2;
        if a[aMidIndex] <= b[bMidIndex] then
            if aMidIndex + bMidIndex >= k then
                // The k-th element is in the first part of a
                GetKthSmallest(a[..aMidIndex], b, k)
            else
                // The k-th element is in the second part of b
                GetKthSmallest(a, b[bMidIndex+1..], k - (aMidIndex + 1))
        else
            if aMidIndex + bMidIndex >= k then
                // The k-th element is in the first part of b
                GetKthSmallest(a, b[..bMidIndex], k)
            else
                // The k-th element is in the second part of a
                GetKthSmallest(a[aMidIndex+1..], b, k - (bMidIndex + 1))
}