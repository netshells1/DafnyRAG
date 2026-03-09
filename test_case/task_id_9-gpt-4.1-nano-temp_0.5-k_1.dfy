predicate RotateRightSeq(s: string, n: int, r: string)
  requires 0 <= n < |s|
  ensures r == RotateRight(s, n)
{
  // This predicate is used to relate the rotation operation to the output string
}

method MinRotationsToSame(s: string) returns (rotations: int)
  ensures (|s| <= 1) ==> rotations == 0
  ensures rotations >= 1 ==> rotations < |s|
  ensures RotateRight(s, rotations) == s
{
    // Handle trivial cases where rotation doesn't change the string
    if |s| <= 1 {
        rotations := 0;
        return;
    }
    var len := |s|;
    var r := 1;
    // Loop to find minimal rotation
    while r < len
        invariant 1 <= r <= len
        invariant RotateRight(s, r) == s
        decreases len - r
    {
        if RotateRight(s, r) == s {
            rotations := r;
            return;
        }
        r := r + 1;
    }
    // If no rotation found, default to 0 (though for strings with length > 1, rotation should be found)
    rotations := 0;
}