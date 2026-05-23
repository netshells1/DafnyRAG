method MaxDifference(a: array<int>) returns (diff: int)
    requires a.Length > 0
    ensures diff == Max(a[..]) - Min(a[..])
{
    var minVal := a[0];
    var maxVal := a[0];

    for i := 1 to a.Length
        invariant 1 <= i <= a.Length
        invariant minVal <= maxVal
        invariant forall k :: 0 <= k < i ==> minVal <= a[k] <= maxVal
        invariant minVal == Min(a[..i])
        invariant maxVal == Max(a[..i])
    {
        if a[i] < minVal {
            minVal := a[i];
        } else if a[i] > maxVal {
            maxVal := a[i];
        }
    }
    diff := maxVal - minVal;
}

// Helper function to find minimum in a sequence
function Min(s: seq<int>): int
    requires |s| > 0
{
    if |s| == 1 then s[0]
    else
        var minPrefix := Min(s[..|s|-1]);
        if s[|s|-1] <= minPrefix then s[|s|-1] else minPrefix
}

// Helper function to find maximum in a sequence
function Max(s: seq<int>): int
    requires |s| > 0
{
    if |s| == 1 then s[0]
    else
        var maxPrefix := Max(s[..|s|-1]);
        if s[|s|-1] >= maxPrefix then s[|s|-1] else maxPrefix
}