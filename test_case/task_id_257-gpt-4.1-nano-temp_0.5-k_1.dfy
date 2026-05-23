method CreateSequence(b: int, a: int) returns (res: seq<int>)
    ensures |res| == 2
    ensures res[0] == b
    ensures res[1] == a
{
    res := [b, a];
}