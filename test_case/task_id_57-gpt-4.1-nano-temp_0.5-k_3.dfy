method FindLargestNumber(a: array<int>) returns (maxNumber: int)
    requires a != null
    ensures maxNumber == Max(a[..])
{
    maxNumber := a[0];
    for i := 1 to a.Length
        invariant 1 <= i <= a.Length
        invariant forall k :: 0 <= k < i ==> a[k] <= maxNumber
        invariant maxNumber == Max(a[..i])
    {
        if a[i] > maxNumber {
            maxNumber := a[i];
        }
    }
}

// Auxiliary function to compute maximum of a sequence
function Max(a: seq<int>) : int
    requires |a| > 0
{
    if |a| == 1 then a[0]
    else
        var maxPrefix := Max(a[..|a|-1]);
        if a[|a|-1] >= maxPrefix then a[|a|-1] else maxPrefix
}