method TetrahedralNumber(n: int) returns (tn: int)
  requires n >= 0
  ensures tn == n * (n + 1) * (n + 2) / 6
{
    tn := 0;
    var i := 0;
    var sum := 0;
    // Loop to sum the first n triangular numbers
    for k := 0 to n
        invariant 0 <= k <= n
        invariant sum == (k * (k + 1) * (k + 2)) / 6
        invariant tn == sum
    {
        sum := sum + (k + 1) * (k + 2) / 2;
        i := i + 1;
    }
    tn := sum;
}