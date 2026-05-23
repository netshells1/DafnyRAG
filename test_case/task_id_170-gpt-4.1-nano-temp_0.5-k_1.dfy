// Helper function to compute sum of a subarray from start to end inclusive
function sumRange(a: array<int>, start: int, end: int): int
    requires a != null
    requires 0 <= start <= end < a.Length
{
    if start > end then 0 else a[start] + sumRange(a, start + 1, end)
}

method RangeSum(a: array<int>, start: int, end: int) returns (sum: int)
    requires a != null
    requires 0 <= start <= end < a.Length
    ensures sum == sumRange(a, start, end)
{
    sum := 0;
    var i := start;
    while i <= end
        invariant start <= i <= end + 1
        invariant sum == sumRange(a, start, i - 1)
    {
        sum := sum + a[i];
        i := i + 1;
    }
}