method CountTrue(a: array<bool>) returns (count: int)
    requires a != null
    ensures count >= 0
    ensures count == |{ i | 0 <= i < a.Length && a[i] }|
{
    count := 0;
    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant count == |{ k | 0 <= k < i && a[k] }|
    {
        if a[i] {
            count := count + 1;
        }
    }
}