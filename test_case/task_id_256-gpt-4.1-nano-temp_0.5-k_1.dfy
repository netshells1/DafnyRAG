predicate IsPrime(k: nat)
{
    k >= 2 && (forall d :: 1 < d < k ==> k % d != 0)
}

method CountPrimesLessThan(n: nat) returns (count: nat)
    requires n >= 0
    ensures count == |{k | 0 <= k < n && IsPrime(k)}|
{
    var c := 0;
    var k := 0;
    while k < n
        invariant 0 <= k <= n
        invariant c == |{i | 0 <= i < k && IsPrime(i)}|
    {
        if k >= 2 && (forall d :: 1 < d < k ==> k % d != 0)
        {
            c := c + 1;
        }
        k := k + 1;
    }
    count := c;
}