method CountArraysInSequence(seqs: seq<array<int>>) returns (count: int)
    ensures count == |seqs|
{
    count := 0;
    var i := 0;
    while i < |seqs|
        invariant 0 <= i <= |seqs|
        invariant count == i
    {
        // No need to process array contents, just count arrays
        count := count + 1;
        i := i + 1;
    }
}