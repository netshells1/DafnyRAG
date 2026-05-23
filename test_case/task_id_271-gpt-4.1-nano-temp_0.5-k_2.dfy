method SumOfFifthPowerOfFirstNEvenNumbers(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == n * (n + 1) * (2 * n + 1) * (3 * n * n + 3 * n - 1) / 3
{
    sum := 0;
    var i := 0; // will iterate over count of even numbers
    var even_number := 2 * i; // starting from 0, then 2, 4, ...
    for k := 0 to n - 1
        invariant 0 <= k <= n
        invariant i == k
        invariant even_number == 2 * k
        invariant sum == k * (k + 1) * (2 * k + 1) * (3 * k * k + 3 * k - 1) / 3
    {
        sum := sum + even_number * even_number * even_number * even_number * even_number;
        i := i + 1;
        even_number := 2 * i;
    }
}