method MedianOfTwoSortedLists(a: seq<int>, b: seq<int>) returns (median: real)
    requires |a| > 0
    requires |b| > 0
    requires |a| == |b|
{
    var merged := MergeSortedSequences(a, b);
    var n := |merged| / 2;
    // Since total length is even, median is average of middle two elements
    var middle1 := merged[n - 1];
    var middle2 := merged[n];
    median := (middle1 as real + middle2 as real) / 2.0;
}

// Helper function to merge two sorted sequences
function MergeSortedSequences(a: seq<int>, b: seq<int>) : seq<int>
    requires |a| >= 0
    requires |b| >= 0
{
    if |a| == 0 then b
    else if |b| == 0 then a
    else
        if a[0] <= b[0] then [a[0]] + MergeSortedSequences(a[1..], b)
        else [b[0]] + MergeSortedSequences(a, b[1..])
}