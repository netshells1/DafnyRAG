function sumOfSubarray(a: array<int>, start: int, end: int): int
    requires 0 <= start <= end < a.Length
    reads a
{
    if start > end then 0 else a[start] + sumOfSubarray(a, start + 1, end)
}

method MaxSubarraySum(a: array<int>) returns (maxSum: int)
    ensures exists start, end :: 0 <= start <= end < a.Length && maxSum == sumOfSubarray(a, start, end)
{
    var n := a.Length;
    if n == 0 {
        maxSum := 0;
        return;
    }
    maxSum := a[0];
    var currentSum := 0;
    var startIdx := 0;
    var maxStart := 0;
    var maxEnd := 0;

    // Kadane's Algorithm implementation
    for i := 0 to n - 1
        invariant 0 <= i <= n
        invariant maxSum >= a[0..i]
        invariant currentSum >= 0
        invariant maxSum == sumOfSubarray(a, maxStart, maxEnd)
    {
        if currentSum <= 0 {
            currentSum := a[i];
            startIdx := i;
        } else {
            currentSum := currentSum + a[i];
        }
        if currentSum > maxSum {
            maxSum := currentSum;
            maxStart := startIdx;
            maxEnd := i;
        }
    }
    // The maximum sum is stored in maxSum
}