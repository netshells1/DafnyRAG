method CountNonEmptySubstrings(s: string) returns (count: int)
    ensures count >= 0
    ensures count == |s| * (|s| + 1) / 2
{
    var n := |s|;
    count := 0;
    var i := 0;
    // Loop over starting positions of substrings
    while i < n
        invariant 0 <= i <= n
        invariant count == (i * (i + 1)) / 2
    {
        var j := i;
        // For each starting position, count substrings ending from i to n-1
        while j < n
            invariant i <= j <= n
            invariant count == (i * (i + 1)) / 2 + (j - i + 1)
        {
            // Each iteration adds one substring: s[i..j]
            count := count + 1;
            j := j + 1;
        }
        i := i + 1;
    }
}