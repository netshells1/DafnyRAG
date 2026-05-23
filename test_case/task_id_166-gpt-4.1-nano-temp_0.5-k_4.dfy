predicate IsXorEven(x: int, y: int)
{
    (x ^ y) % 2 == 0
}

method CountXorEvenPairs(a: array<int>) returns (count: int)
    requires a != null
    ensures count == |{ (i, j) | 0 <= i < j < a.Length && IsXorEven(a[i], a[j]) }|
{
    count := 0;
    var n := a.Length;
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        // The count holds for all pairs with indices less than i
        invariant count == |{ (x, y) | 0 <= x < y < i && IsXorEven(a[x], a[y]) }|
    {
        var j := i + 1;
        while j < n
            invariant i + 1 <= j <= n
            // The count includes pairs with first index i and second index less than j
            invariant count == |{ (x, y) | 0 <= x < y < i && IsXorEven(a[x], a[y]) }| + |{ (i, y) | i < y < j && IsXorEven(a[i], a[y]) }|
        {
            if IsXorEven(a[i], a[j]) {
                count := count + 1;
            }
            j := j + 1;
        }
        i := i + 1;
    }
}