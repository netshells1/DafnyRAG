method SumOfCubesOfFirstNEvenNumbers(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == n * (n + 1) * (2 * n + 1)
{
    sum := 0;
    var i := 2; // first even number
    for k := 0 to n - 1
        invariant 0 <= k <= n
        invariant i == 2 * (k + 1)
        invariant sum == k * (k + 1) * (2 * k + 1)
    {
        sum := sum + i * i * i;
        i := i + 2;
    }
}