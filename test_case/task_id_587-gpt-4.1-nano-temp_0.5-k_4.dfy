method ArrayToSequence(a: array<int>) returns (seqResult: seq<int>)
    requires a != null
    ensures seqResult == a[..]
{
    var s: seq<int> := "";
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant s == a[..i]
    {
        s := s + a[i];
        i := i + 1;
    }
    seqResult := s;
}