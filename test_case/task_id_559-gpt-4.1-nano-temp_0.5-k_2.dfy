method MaxSubArraySum(a: array<int>) returns (maxSum: int)
    requires a != null
    ensures exists start, end :: 0 <= start <= end < a.Length && maxSum == sum(a[start..end+1])
{
    var currentSum := 0;
    maxSum := 0;
    var startIdx := 0;
    var tempStart := 0;

    // Initialize maxSum with the first element if array is non-empty
    if a.Length > 0 {
        maxSum := a[0];
        currentSum := 0;
        startIdx := 0;
        tempStart := 0;

        for i := 0 to a.Length - 1
            invariant 0 <= i <= a.Length
            invariant currentSum == sum(a[tempStart..i])
            invariant maxSum >= currentSum
            invariant 0 <= tempStart <= i
        {
            currentSum := currentSum + a[i];

            if currentSum > maxSum {
                maxSum := currentSum;
                startIdx := tempStart;
            }
            if currentSum < 0 {
                currentSum := 0;
                tempStart := i + 1;
            }
        }
    } else {
        // For empty array, define maxSum as 0
        maxSum := 0;
    }
}