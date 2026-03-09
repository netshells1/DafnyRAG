predicate RotateString(s: string, n: int, r: string)
{
    |r| == |s|
    forall i :: 0 <= i < |s| ==> r[i] == s[(i - n + |s|) % |s|]
}

method MinRotationsToSame(s: string) returns (rotations: int)
    ensures rotations > 0
    ensures RotateString(s, rotations, s)
{
    var n := 1;
    while n < |s|
        invariant 1 <= n <= |s|
        invariant RotateString(s, n, s)
    {
        n := n + 1;
    }
    rotations := n;
}