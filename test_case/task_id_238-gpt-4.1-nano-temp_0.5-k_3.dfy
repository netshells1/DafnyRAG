method CountNonEmptySubstrings(s: string) returns (count: nat)
    ensures count >= 0
    ensures count == | { i, j :: 0 <= i <= j < |s|+1 } |  // Counting all substrings s[i..j], with i <= j
{
    var n := |s|;
    count := 0;
    var i := 0;
    // Loop over starting indices
    while i <= n
        invariant 0 <= i <= n
        // For each starting index, count substrings ending at positions j >= i
        invariant count == sum j := i..n :: (j - i + 1)
    {
        var j := i;
        // Loop over ending indices
        while j < n
            invariant i <= j <= n
            invariant count == sum k := i..j :: (k - i + 1)
        {
            // Each pair (i, j) with i <= j corresponds to a non-empty substring s[i..j]
            count := count + 1;
            j := j + 1;
        }
        i := i + 1;
    }
}