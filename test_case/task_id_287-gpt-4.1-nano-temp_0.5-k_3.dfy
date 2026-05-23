method SumOfSquaresOfFirstNEvenNumbers(n: int) returns (sum: int)
  requires n >= 0
  ensures sum == n * (n + 1) * (4 * n * n + 6 * n + 1) / 3
{
    sum := 0;
    var i := 0;
    for k := 0 to n
        invariant 0 <= k <= n
        invariant i == 2 * k
        invariant sum == k * (k + 1) * (4 * k * k + 6 * k + 1) / 3
    {
        sum := sum + i * i;
        i := i + 2;
    }
}