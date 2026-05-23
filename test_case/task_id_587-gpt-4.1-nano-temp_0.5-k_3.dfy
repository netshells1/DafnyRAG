method ArrayToSequence(a: array<int>) returns (seqResult: seq<int>)
    requires a != null
{
    seqResult := a[..]; // Convert array to sequence
}