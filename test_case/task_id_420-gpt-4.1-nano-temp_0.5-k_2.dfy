method SumOfCubesOfFirstNEvenNumbers(n: int) returns (sum: int)
  requires n >= 0
  ensures sum == n * (n + 1) * (2 * n + 1)
{
    sum := 0;
    var i := 0;
    for k := 1 to n
        invariant 1 <= k <= n + 1
        invariant i == 2 * (k - 1)
        invariant sum == (k - 1) * k * (2 * (k - 1) + 1)
    {
        sum := sum + (2 * k) * (2 * k) * (2 * k);
        i := i + 2;
    }
}