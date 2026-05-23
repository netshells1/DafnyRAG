method SumOfCubesOfFirstNEvenNumbers(n: int) returns (sum: int)
  requires n >= 0
  ensures sum == 4 * n * (n + 1) * (2 * n + 1) / 3
{
    sum := 0;
    var i := 0;
    for k := 0 to n
        invariant 0 <= k <= n
        invariant i == 2 * k
        invariant sum == 4 * k * (k + 1) * (2 * k + 1) / 3
    {
        sum := sum + i * i * i;
        i := i + 2;
    }
}