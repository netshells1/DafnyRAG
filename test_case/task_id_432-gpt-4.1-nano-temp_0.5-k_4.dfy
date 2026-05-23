method MedianTrapeziumLength(a: array<int>, b: array<int>) returns (median: real)
    requires a.Length > 0 && a.Length == b.Length
    ensures median == MedianOfLengths(a, b)
{
    var lengths := new real[a.Length];
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant lengths[..i] == [real(a[k] + b[k]) | k := 0 .. i-1]
    {
        lengths[i] := (a[i] + b[i]) as real;
        i := i + 1;
    }
    median := ComputeMedian(lengths);
}

function MedianOfLengths(a: array<int>, b: array<int>): real
    requires a.Length > 0 && a.Length == b.Length
{
    var lengths := [real(a[k] + b[k]) | k := 0 .. a.Length - 1];
    ComputeMedian(lengths)
}

function ComputeMedian(seq: seq<real>): real
    requires |seq| > 0
{
    var sorted := seq[..].Sort();
    if |sorted| % 2 == 1 then
        sorted[|sorted| / 2]
    else
        (sorted[|sorted| / 2 - 1] + sorted[|sorted| / 2]) / 2.0
}