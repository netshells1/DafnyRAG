method MaxSubArraySum(a: array<int>) returns (maxSum: int)
    requires a != null
    ensures exists start, end :: 0 <= start <= end < a.Length && maxSum == sum(a[start..end+1])
{
    var currentSum := 0;
    maxSum := if a.Length > 0 then a[0] else 0;
    var tempSum := 0;
    var startIndex := 0;
    var maxStart := 0;
    var maxEnd := 0;

    for i := 0 to a.Length - 1
        invariant 0 <= i <= a.Length
        invariant currentSum == sum(a[startIndex..i+1])
        invariant maxSum >= currentSum
        invariant 0 <= startIndex <= i
        invariant 0 <= maxStart <= maxEnd < a.Length
        invariant maxSum == sum(a[maxStart..maxEnd+1])
    {
        if currentSum + a[i] >= a[i] then
        {
            currentSum := currentSum + a[i];
        } else
        {
            currentSum := a[i];
            startIndex := i;
        }
        if currentSum > maxSum then
        {
            maxSum := currentSum;
            maxStart := startIndex;
            maxEnd := i;
        }
    }
}