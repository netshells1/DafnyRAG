function sumRange(a: array<int>, i: int, j: int): int
    requires a != null;
    requires 0 <= i <= j < a.Length;
{
    if i > j then 0 else a[i] + sumRange(a, i + 1, j)
}

method RangeSum(a: array<int>, start: int, end: int) returns (sum: int)
    requires a != null;
    requires 0 <= start <= end < a.Length;
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