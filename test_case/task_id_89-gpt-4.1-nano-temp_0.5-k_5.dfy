method ClosestSmaller(n: int, a: array<int>) returns (result: int?)
    requires a != null
    ensures (exists x :: x in a[..] && x < n) ==> (result != null && result in a[..] && result < n && forall y :: y in a[..] && y < n ==> y <= result)
    ensures (forall y :: y in a[..] && y < n ==> y <= result)
    ensures result == null <==> (forall y :: y in a[..] ==> y >= n)
{
    var candidate: int? := null;
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant (exists x :: x in a[..i] && x < n) ==> (candidate != null && candidate in a[..i] && candidate < n && forall y :: y in a[..i] && y < n ==> y <= candidate)
        invariant (forall y :: y in a[..i] ==> y >= n) ==> candidate == null
        invariant (candidate != null) ==> candidate in a[..i]
    {
        if a[i] < n {
            if candidate == null || a[i] > candidate {
                candidate := a[i];
            }
        }
        i := i + 1;
    }
    result := candidate;
}