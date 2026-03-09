predicate RotateString(s: string, r: int)
{
    s == RotateStringBy(s, r)
}

method RotateStringBy(s: string, r: int): string
{
    var len := s.Length;
    if len == 0 {
        return s;
    }
    var r_mod := r % len;
    return s[len - r_mod ..] + s[..len - r_mod];
}

method MinRotationsToMatch(s: string) returns (rotations: int)
    requires s != null
    ensures rotations > 0
    ensures RotateString(s, rotations) == s
    ensures forall r :: 0 < r < rotations ==> RotateString(s, r) != s
{
    var len := s.Length;
    // For non-empty strings
    // Find minimal r > 0 such that RotateString(s, r) == s
    var r := 1;
    while r <= len
        invariant 1 <= r <= len + 1
        invariant (r > len) ==> RotateString(s, len) == s
        invariant (r <= len) ==> RotateString(s, r) != s
    {
        if r > len {
            // No smaller rotation found, full rotation
            return len;
        }
        if RotateString(s, r) == s {
            return r;
        }
        r := r + 1;
    }
    // If loop completes without return, then rotation is full length
    return len;
}