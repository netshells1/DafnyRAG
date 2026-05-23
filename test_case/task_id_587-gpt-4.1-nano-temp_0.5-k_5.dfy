method ArrayToSequence(a: array<int>) returns (seq: seq<int>)
    requires a != null
    ensures seq == a[..]
{
    var s := [];
    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant s == a[..i]
    {
        s := s + [a[i]];
    }
    return s;
}