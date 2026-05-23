method MedianTrapeziumLength(a: array<int>) returns (median: int)
    requires a != null
    requires a.Length > 0
    ensures median == (if a.Length % 2 == 1 then Sorted(a)[a.Length / 2] else Sorted(a)[(a.Length / 2) - 1])
{
    var sorted := a[..];
    // Sort the array
    // Using a simple insertion sort for demonstration
    var i := 1;
    while i < a.Length
        invariant 1 <= i <= a.Length
        invariant sorted[..i] == a[..i]
        invariant sorted[..i] == Sorted(a[..i])
    {
        var key := sorted[i];
        var j := i - 1;
        while j >= 0 && sorted[j] > key
            invariant -1 <= j < i
            invariant forall k :: 0 <= k <= j ==> sorted[k] <= key
        {
            sorted[j + 1] := sorted[j];
            j := j - 1;
        }
        sorted[j + 1] := key;
        i := i + 1;
    }
    if a.Length % 2 == 1 {
        median := sorted[a.Length / 2];
    } else {
        median := sorted[(a.Length / 2) - 1];
    }
}

// Auxiliary function to produce sorted sequence
function Sorted(s: seq<int>): seq<int>
    ensures |Sorted(s)| == |s|
{
    if |s| <= 1 then s
    else
        var pivot := s[0];
        var less := s[1..] |> Seq.filter(x => x <= pivot);
        var greater := s[1..] |> Seq.filter(x => x > pivot);
        Sorted(less) + [pivot] + Sorted(greater)
}