method TetrahedralNumber(n: int) returns (t: int)
    requires n >= 0
    ensures t == n * (n + 1) * (n + 2) / 6
{
    t := 0;
    var i := 0;
    for k := 0 to n
        invariant 0 <= k <= n
        invariant t == k * (k + 1) * (k + 2) / 6
        invariant i == k
    {
        t := t + (i + 1) * (i + 2) / 2; // sum of tetrahedral numbers increment
        i := i + 1;
    }
}