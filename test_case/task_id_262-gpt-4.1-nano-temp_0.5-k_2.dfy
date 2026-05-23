method SplitArrayAtL(a: array<int>, L: int) returns (result: seq<int>)
    requires 0 <= L <= a.Length
    ensures result == a[..L]
    ensures |result| == L
{
    var res: seq<int> := [];
    var i: int := 0;
    while i < L
        invariant 0 <= i <= L
        invariant res == a[..i]
        decreases L - i
    {
        res := res + [a[i]];
        i := i + 1;
    }
    result := res;
}