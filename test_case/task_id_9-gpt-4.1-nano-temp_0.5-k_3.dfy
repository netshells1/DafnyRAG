predicate RotateRight(s: string, n: int, r: string)
{
    |r| == |s| &&
    forall i :: 0 <= i < |s| ==> r[i] == s[(i - n + |s|) % |s|]
}

method MinRotations(s: string) returns (rotations: int)
    requires s.Length > 0
    ensures rotations > 0
    ensures rotations < |s|
    ensures RotateRight(s, rotations, s)
{
    var len := |s|;
    rotations := 1;
    while rotations < len
        invariant 1 <= rotations < len
        invariant RotateRight(s, rotations, s)
    {
        if RotateRight(s, rotations, s)
        {
            break;
        }
        rotations := rotations + 1;
    }
}