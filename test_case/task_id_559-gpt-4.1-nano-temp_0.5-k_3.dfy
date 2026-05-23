function method MaximumSubArraySum(a: array<int>) : int
    requires a != null
{
    if a.Length == 0 then 0
    else
        var maxEndingHere := a[0];
        var maxSoFar := a[0];
        var i := 1;
        while i < a.Length
            invariant 1 <= i <= a.Length
            invariant maxEndingHere == MaxSuffixSum(a, 0, i)
            invariant maxSoFar == MaxSubArraySumPrefix(a, 0, i)
        {
            if maxEndingHere + a[i] > a[i] {
                maxEndingHere := maxEndingHere + a[i];
            } else {
                maxEndingHere := a[i];
            }
            if maxEndingHere > maxSoFar {
                maxSoFar := maxEndingHere;
            }
            i := i + 1;
        }
        maxSoFar
}

function MaxSuffixSum(a: array<int>, start: int, end: int): int
    requires 0 <= start <= end <= a.Length
{
    var sum := 0;
    var maxSum := a[start];
    var i := start;
    while i < end
        invariant start <= i <= end
        invariant sum == sum of a[start..i)
        invariant maxSum >= a[start]
    {
        sum := sum + a[i];
        if sum > maxSum {
            maxSum := sum;
        }
        i := i + 1;
    }
    maxSum
}

function MaxSubArraySumPrefix(a: array<int>, start: int, end: int): int
    requires 0 <= start <= end <= a.Length
{
    if start == end then 0
    else
        var maxSum := a[start];
        var currentSum := a[start];
        var i := start + 1;
        while i < end
            invariant start + 1 <= i <= end
            invariant currentSum == sum of a[start..i)
            invariant maxSum >= a[start]
        {
            currentSum := currentSum + a[i];
            if currentSum > maxSum {
                maxSum := currentSum;
            }
            i := i + 1;
        }
        maxSum
}