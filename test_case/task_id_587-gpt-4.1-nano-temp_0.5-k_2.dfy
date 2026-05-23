method ArrayToSequence(a: array<int>) returns (seqResult: seq<int>)
    requires a != null
    ensures seqResult == Seq.FromArray(a)
    ensures |seqResult| == a.Length
{
    seqResult := Seq.Empty;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant seqResult == Seq.FromArray(a[..i])
    {
        seqResult := Seq.Concat(seqResult, a[i]);
        i := i + 1;
    }
}