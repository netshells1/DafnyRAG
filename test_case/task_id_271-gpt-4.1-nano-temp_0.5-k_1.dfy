method SumOfFirstNEvenNumbersRaisedToFifthPower(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == n * (n + 1) * (2 * n + 1) * (3 * n * n + 3 * n - 1) / 3
{
    sum := 0;
    var i := 1;
    for k := 0 to n - 1
        invariant 0 <= k <= n
        invariant i == 2 * k + 2
        invariant sum == k * (k + 1) * (2 * k + 1) * (3 * k * k + 3 * k - 1) / 3
    {
        sum := sum + i * i * i * i * i; // fifth power of even number i
        i := i + 2;
    }
}