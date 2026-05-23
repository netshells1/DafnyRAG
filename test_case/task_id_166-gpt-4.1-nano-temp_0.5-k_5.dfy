predicate IsEven(n: int)
{
    n % 2 == 0
}

method CountXorEvenPairs(a: array<int>) returns (count: int)
    requires a != null
    ensures count == |{ (i, j) | 0 <= i < j < a.Length && (a[i] ^ a[j]) % 2 == 0 }|
{
    count := 0;
    var n := a.Length;
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant count >= 0
        // For each i, count of pairs with indices less than i
        invariant 0 <= i <= n
    {
        var j := i + 1;
        while j < n
            invariant i + 1 <= j <= n
            invariant count >= 0
        {
            if ((a[i] ^ a[j]) % 2 == 0)
            {
                count := count + 1;
            }
            j := j + 1;
        }
        i := i + 1;
    }
}