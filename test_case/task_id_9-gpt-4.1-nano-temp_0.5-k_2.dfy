method MinRotationsToMatch(s: string) returns (rotations: int)
    requires s != null
    ensures rotations >= 0
    ensures (|s| == 0 || |s| == 1) ==> rotations == 0
    ensures |s| > 1 ==> exists k :: 1 <= k < |s| && RotateRight(s, k) == s && rotations == k
    ensures for all k :: 1 <= k < |s| :: RotateRight(s, k) != s
{
    if |s| <= 1 {
        return 0;
    }
    var n := |s|;
    var minRotation := 0;
    var found := false;
    var k := 1;
    while k < n
        invariant 1 <= k <= n
        invariant !found ==> exists j :: 1 <= j <= k && RotateRight(s, j) == s
        invariant found ==> minRotation == j
    {
        if RotateRight(s, k) == s {
            minRotation := k;
            found := true;
            break;
        }
        k := k + 1;
    }
    if found {
        return minRotation;
    } else {
        // No rotation produces the same string except trivial case
        return 0;
    }
}

predicate RotateRight(s: string, n: int)
    requires n >= 0
{
    var len := |s|;
    if len == 0 then
        true
    else
        s == s[len - n % len ..] + s[..len - n % len]
}