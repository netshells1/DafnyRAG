predicate IsPrime(k: int)
{
    k >= 2 && (forall d :: d > 1 && d * d <= k ==> k % d != 0)
}

method CountPrimesLessThan(n: int) returns (count: int)
    requires n >= 0
    ensures count == |{k: int | 0 <= k < n && IsPrime(k)}|
{
    count := 0;
    var k := 0;
    while k < n
        invariant 0 <= k <= n
        invariant count == |{j: int | 0 <= j < k && IsPrime(j)}|
    {
        if k >= 2 && IsPrime(k)
        {
            count := count + 1;
        }
        k := k + 1;
    }
}