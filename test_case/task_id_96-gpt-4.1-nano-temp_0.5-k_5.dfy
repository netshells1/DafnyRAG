predicate Divides(d: int, n: int)
{
    n % d == 0
}

method CountDivisors(n: int) returns (count: int)
    ensures count >= 0
    ensures count == | { d: int | d > 0 && Divides(d, n) } |
{
    var c := 0;
    var absN := if n >= 0 then n else -n;
    var d := 1;
    while d <= absN
        invariant 1 <= d <= absN + 1
        invariant c >= 0
        invariant c == | { k: int | 1 <= k < d && Divides(k, n) } |
    {
        if n % d == 0 {
            c := c + 1;
        }
        d := d + 1;
    }
    count := c;
}