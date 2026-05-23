predicate Divides(d: int, m: int)
{
    m % d == 0
}

method CountDivisors(n: int) returns (count: int)
    ensures count >= 0
    ensures count == | { d: int | d > 0 && Divides(d, if n >= 0 then n else -n) } |
{
    var absN := if n >= 0 then n else -n;
    count := 0;
    var d := 1;
    while d <= absN
        invariant 1 <= d <= absN + 1
        invariant count == |{ i: int | 1 <= i < d && Divides(i, absN) }|
    {
        if absN % d == 0 {
            count := count + 1;
        }
        d := d + 1;
    }
}