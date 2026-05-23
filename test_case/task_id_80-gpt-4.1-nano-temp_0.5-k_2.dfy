method TetrahedralNumber(n: int) returns (t: int)
  requires n >= 0
  ensures t == n * (n + 1) * (n + 2) / 6
{
    t := 0;
    var i := 1;
    var sum_triangular := 0;
    // Loop from 1 to n to sum the first n triangular numbers
    for k := 1 to n
        invariant 1 <= k <= n + 1
        invariant sum_triangular == (k - 1) * k / 2
        invariant t == sum_triangular
        // At each step, add the kth triangular number
    {
        sum_triangular := sum_triangular + k * (k + 1) / 2;
        t := t + k * (k + 1) / 2;
    }
}