predicate IsPositive(x: int)
{
    x > 0
}

method CountPositiveNumbers(a: array<int>) returns (count: int)
    requires a != null
    ensures count >= 0
    ensures count == | { i: int | 0 <= i < a.Length && a[i] > 0 } |
{
    var c := 0;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant c >= 0
        invariant c == | { k: int | 0 <= k < i && a[k] > 0 } |
    {
        if a[i] > 0 {
            c := c + 1;
        }
        i := i + 1;
    }
    count := c;
}