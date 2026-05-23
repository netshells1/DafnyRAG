method CountArraysInSequence(seqOfArrays: seq<array<int>>) returns (count: int)
    ensures 0 <= count <= |seqOfArrays|
    ensures count == | { a: array<int> | a in seqOfArrays && a != null } |
{
    count := 0;
    var i := 0;
    while i < |seqOfArrays|
        invariant 0 <= i <= |seqOfArrays|
        invariant count == |{ a: array<int> | a in seqOfArrays[..i] && a != null }|
    {
        if seqOfArrays[i] != null {
            count := count + 1;
        }
        i := i + 1;
    }
}