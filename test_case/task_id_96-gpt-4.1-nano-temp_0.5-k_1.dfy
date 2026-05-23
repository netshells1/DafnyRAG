method CountDivisors(n: int) returns (count: int)
    requires n >= 0
    ensures count == |{ d: int | 1 <= d <= n && n % d == 0 }|
{
    var c := 0;
    var d := 1;
    while d <= n
        invariant 1 <= d <= n + 1
        invariant c == |{ k: int | 1 <= k < d && n % k == 0 }|
    {
        if n % d == 0 {
            c := c + 1;
        }
        d := d + 1;
    }
    count := c;
}