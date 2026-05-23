function sumInRange(a: array<int>, start: int, end: int): int
    requires a != null
    requires 0 <= start <= end < a.Length
{
    if start > end then 0 else a[start] + sumInRange(a, start + 1, end)
}

method RangeSum(a: array<int>, start: int, end: int) returns (sum: int)
    requires a != null
    requires 0 <= start <= end < a.Length
    ensures sum == sumInRange(a, start, end)
{
    sum := 0;
    var i := start;
    while i <= end
        invariant start <= i <= end + 1
        invariant sum == sumInRange(a, start, i - 1)
    {
        if i <= end {
            sum := sum + a[i];
            i := i + 1;
        }
    }
}