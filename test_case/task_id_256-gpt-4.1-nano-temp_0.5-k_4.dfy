predicate IsPrime(k: int)
{
    k >= 2 && (forall d :: d > 1 && d * d <= k ==> k % d != 0)
}

method CountPrimesLessThan(n: int) returns (count: int)
    requires n >= 0
    ensures count == |{k: int | 0 <= k < n && IsPrime(k)}|
{
    var c := 0;
    var k := 0;
    while k < n
        invariant 0 <= k <= n
        invariant c == |{i: int | 0 <= i < k && IsPrime(i)}|
    {
        if k >= 2 && IsPrime(k)
        {
            c := c + 1;
        }
        k := k + 1;
    }
    count := c;
}