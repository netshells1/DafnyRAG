method MedianOfTwoSortedLists(a: seq<int>, b: seq<int>) returns (median: real)
    requires |a| > 0 && |a| == |b|
    ensures median == 
        if (|a| + |b|) % 2 == 1 then
            // Odd total length: median is the middle element
            if (|a| + |b|) == 1 then (a[0] + b[0]) / 2.0
            else (if (|a| + |b|) / 2 < |a| then
                      // Middle element in a
                      a[(|a| + |b|) / 2]
                  else
                      // Middle element in b
                      b[(|a| + |b|) / 2 - |a|]
                  )
        else
            // Even total length: average of the two middle elements
            let idx1 := (|a| + |b|) / 2 - 1 in
            let idx2 := (|a| + |b|) / 2 in
            ( // median is average of the two middle elements
              if idx1 < |a| then a[idx1] else b[idx1 - |a|]
            + 
              if idx2 < |a| then a[idx2] else b[idx2 - |a|]
            ) / 2.0
{
    var total := |a| + |b|;
    if total % 2 == 1 {
        // Odd length
        var mid := total / 2;
        if mid < |a| {
            median := a[mid];
        } else {
            median := b[mid - |a|];
        }
    } else {
        // Even length
        var mid1 := total / 2 - 1;
        var mid2 := total / 2;
        var val1 := if mid1 < |a| then a[mid1] else b[mid1 - |a|];
        var val2 := if mid2 < |a| then a[mid2] else b[mid2 - |a|];
        median := (val1 + val2) / 2.0;
    }
}