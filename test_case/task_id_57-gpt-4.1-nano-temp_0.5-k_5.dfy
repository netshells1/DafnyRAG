method FindLargest(a: array<int>) returns (max: int)
    requires a != null
    ensures max == Max(a[..])
{
    max := a[0];
    for i := 1 to a.Length
        invariant 1 <= i <= a.Length
        invariant max >= a[0..i]
        invariant forall k :: 0 <= k < i ==> a[k] <= max
    {
        if a[i] > max {
            max := a[i];
        }
    }
}

function Max(a: seq<int>) : int
    requires |a| > 0
{
    if |a| == 1 then a[0]
    else
        var maxPrefix := Max(a[..|a|-1]);
        if a[|a|-1] >= maxPrefix then a[|a|-1] else Max(a[..|a|-1])
}