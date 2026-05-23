method CountPositiveNumbers(a: array<int>) returns (count: int)
    requires a != null
    ensures count >= 0
    ensures count == |{ i: int | 0 <= i < a.Length && a[i] > 0 }|
{
    count := 0;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant count == |{ k: int | 0 <= k < i && a[k] > 0 }|
    {
        if a[i] > 0 {
            count := count + 1;
        }
        i := i + 1;
    }
}