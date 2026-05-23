function Min(a: seq<int>): int
  requires |a| > 0
{
  if |a| == 1 then a[0]
  else
    var minRest := Min(a[..|a|-1]);
    if a[|a|-1] <= minRest then a[|a|-1] else minRest
}

function Max(a: seq<int>): int
  requires |a| > 0
{
  if |a| == 1 then a[0]
  else
    var maxRest := Max(a[..|a|-1]);
    if a[|a|-1] >= maxRest then a[|a|-1] else maxRest
}

method SumLargestSmallest(a: array<int>) returns (sum: int)
    requires a != null
    requires a.Length > 0
    ensures sum == Max(a[..]) + Min(a[..])
{
    var maxVal := a[0];
    var minVal := a[0];
    var i := 1;
    while i < a.Length
        invariant 1 <= i <= a.Length
        invariant minVal <= maxVal
        invariant forall k :: 0 <= k < i ==> minVal <= a[k] <= maxVal
        invariant maxVal == Max(a[..i])
        invariant minVal == Min(a[..i])
    {
        if a[i] > maxVal {
            maxVal := a[i];
        }
        if a[i] < minVal {
            minVal := a[i];
        }
        i := i + 1;
    }
    sum := maxVal + minVal;
}