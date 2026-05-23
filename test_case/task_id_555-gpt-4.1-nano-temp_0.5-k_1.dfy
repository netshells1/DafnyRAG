method SumCubeMinusSum(n: int) returns (diff: int)
    requires n >= 0
    ensures diff == (n * (n + 1) / 2) * (n * (n + 1) - 1)
{
    var sumCubes := 0;
    var sumNumbers := 0;
    var i := 1;
    for k := 0 to n
        invariant 0 <= k <= n
        invariant sumCubes == k * (k + 1) * (2 * k + 1) / 6
        invariant sumNumbers == k * (k + 1) / 2
        invariant i == k + 1
    {
        sumCubes := sumCubes + i * i * i;
        sumNumbers := sumNumbers + i;
        i := i + 1;
    }
    diff := sumCubes - sumNumbers;
}