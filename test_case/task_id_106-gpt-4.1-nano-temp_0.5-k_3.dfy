method AppendArrayToSequence(a: array<int>, s: seq<int>) returns (result: seq<int>)
    ensures result == s + a[..]
{
    var seqA := if a == null then [] else a[..];
    result := seqA + s;
}