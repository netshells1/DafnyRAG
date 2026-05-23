method SplitAndAppend(l: seq<int>, n: int) returns (result: seq<int>)
    requires 0 <= n <= |l|
    ensures result == l[n..] + l[..n]
    ensures |result| == |l|
{
    // Concatenate the suffix starting at n with the prefix up to n-1
    result := l[n..] + l[..n];
}