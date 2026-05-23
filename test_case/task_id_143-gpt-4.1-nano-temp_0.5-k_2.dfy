method CountArraysInSequence(seq: seq<array<int>>) returns (count: int)
    ensures count >= 0
    ensures count == |seq|
{
    count := |seq|;
}