method AppendArrayToSeq(a: array<int>, s: seq<int>) returns (result: seq<int>)
    requires a != null
    ensures result == s + a[..]
{
    var seqFromArray := a[..]; // Convert array to sequence
    result := s + seqFromArray;
}