method CountTrue(a: array<bool>) returns (count: int)
    requires a != null
    ensures count >= 0
    ensures count == | set i: int | 0 <= i < a.Length && a[i] == true |
{
    count := 0;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant count == | {k: int | 0 <= k < i && a[k] == true} |
    {
        if a[i] {
            count := count + 1;
        }
        i := i + 1;
    }
}