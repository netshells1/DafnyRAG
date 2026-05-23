method CountNonEmptySubstrings(s: string) returns (count: nat)
    requires s != null
    ensures count == |s| * (|s| + 1) / 2
{
    var n := |s|;
    count := 0;
    // Loop over all possible starting indices
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant count == (i * (i + 1)) / 2
    {
        var j := i;
        // For each starting position, count substrings ending at positions >= i
        while j < n
            invariant i <= j <= n
            invariant count == (i * (i + 1)) / 2 + (j - i + 1)
        {
            count := count + 1;
            j := j + 1;
        }
        i := i + 1;
    }
}