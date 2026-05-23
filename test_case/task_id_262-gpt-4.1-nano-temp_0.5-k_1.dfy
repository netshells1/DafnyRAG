method SplitArrayAtL(a: array<int>, L: int) returns (result: seq<int>)
    requires a != null
    requires 0 <= L <= a.Length
    ensures result == a[..L] + a[L..]
    ensures |result| == a.Length
{
    var resSeq := seq<int>{};
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant resSeq == a[..i]
        decreases a.Length - i
    {
        resSeq := resSeq + seq<int>{a[i]};
        i := i + 1;
    }
    result := resSeq;
}