method CountNonEmptySubstrings(s: string) returns (count: int)
    requires s != null
    ensures count >= 0
    ensures count == (|s| * (|s| + 1)) / 2
{
    // The total number of non-empty substrings of a string of length n is n*(n+1)/2
    count := (|s| * (|s| + 1)) / 2;
}