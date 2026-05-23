predicate IsPrime(p: int)
{
    p >= 2 && (forall k :: 2 <= k < p ==> p % k != 0)
}

method CountPrimesLessThan(n: int) returns (count: int)
    requires n >= 0
    ensures count == |{ p: int | 2 <= p < n && IsPrime(p) }|
{
    var c := 0;
    var p := 2;
    while p < n
        invariant 0 <= p <= n
        invariant c == |{ q: int | 2 <= q < p && IsPrime(q) }|
    {
        if IsPrime(p)
        {
            c := c + 1;
        }
        p := p + 1;
    }
    count := c;
}