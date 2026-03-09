method CountTrue(a: array<bool>) returns (count: int)
    requires a != null
    ensures count == (if a.Length == 0 then 0 else (var c := 0; var i := 0; while i < a.Length { if a[i] { c := c + 1; } i := i + 1; } c))
{
    count := 0;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant count == (var c := 0; var k := 0; while k < i { if a[k] { c := c + 1; } k := k + 1; } c)
    {
        if a[i] {
            count := count + 1;
        }
        i := i + 1;
    }
}