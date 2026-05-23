function sumToRange(a: array<int>, i: int, j: int): int
    requires a != null;
    requires 0 <= i <= j < a.Length;
    decreases j - i;
{
    if i > j then 0 else a[i] + sumToRange(a, i + 1, j)
}

method ArrayRangeSum(a: array<int>, start: int, end: int) returns (sum: int)
    requires a != null;
    requires 0 <= start <= end < a.Length;
    ensures sum == sumToRange(a, start, end)
{
    sum := 0;
    var i := start;
    while i <= end
        invariant start <= i <= end + 1
        invariant sum == sumToRange(a, start, i - 1)
    {
        sum := sum + a[i];
        i := i + 1;
    }
}