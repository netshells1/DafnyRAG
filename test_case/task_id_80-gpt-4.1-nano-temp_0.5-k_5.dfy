method TetrahedralNumber(n: int) returns (t: int)
  requires n >= 0
  ensures t == n * (n + 1) * (n + 2) / 6
{
    t := 0;
    var i := 0;
    var sum := 0;
    // Loop to compute the nth tetrahedral number
    for i := 0 to n
        invariant 0 <= i <= n
        invariant sum == i * (i + 1) * (i + 2) / 6
    {
        sum := sum + (i + 1) * (i + 2) / 2; // sum of first i+1 triangular numbers
    }
    t := sum;
}