predicate IsEven(n: int)
{
    n % 2 == 0
}

method CountXorEvenPairs(a: array<int>) returns (count: int)
    requires a != null
    ensures count == |{ (i, j) | 0 <= i < j < a.Length && ((a[i] ^ a[j]) % 2 == 0) }|
{
    count := 0;
    var n := a.Length;
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        decreases n - i
    {
        var j := i + 1;
        while j < n
            invariant i + 1 <= j <= n
            invariant count >= 0
            invariant count == |{ (x, y) | 0 <= x < i && x < y < j && ((a[x] ^ a[y]) % 2 == 0) }| + |{ (x, y) | i <= x < j && x < y < n && ((a[x] ^ a[y]) % 2 == 0) }|
            decreases n - j
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