method ArrayToSequence(a: array<int>) returns (seqResult: seq<int>)
    requires a != null
    ensures seqResult == a[..]
{
    seqResult := [];
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant seqResult == a[0..i]
    {
        seqResult := seqResult + [a[i]];
        i := i + 1;
    }
}