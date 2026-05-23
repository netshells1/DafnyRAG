method CountTrues(a: array<bool>) returns (count: int)
    requires a != null
    ensures count == |{ i | 0 <= i < a.Length && a[i] }|
{
    count := 0;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant count == |{ k | 0 <= k < i && a[k] }|
    {
        if a[i] {
            count := count + 1;
        }
        i := i + 1;
    }
}