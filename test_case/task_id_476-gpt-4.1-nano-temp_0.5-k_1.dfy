function Min(a: seq<int>) : int
  requires |a| > 0
{
  if |a| == 1 then a[0]
  else
    var minPrefix := Min(a[..|a|-1]);
    if a[|a|-1] <= minPrefix then a[|a|-1] else minPrefix
}

function Max(a: seq<int>) : int
  requires |a| > 0
{
  if |a| == 1 then a[0]
  else
    var maxPrefix := Max(a[..|a|-1]);
    if a[|a|-1] >= maxPrefix then a[|a|-1] else maxPrefix
}

method SumLargestSmallest(a: array<int>) returns (sum: int)
  requires a != null
  ensures sum == Max(a[..]) + Min(a[..])
{
  var minVal := a[0];
  var maxVal := a[0];
  var i := 1;
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant minVal == Min(a[..i])
    invariant maxVal == Max(a[..i])
    invariant 0 <= i <= a.Length
  {
    if a[i] < minVal {
      minVal := a[i];
    }
    if a[i] > maxVal {
      maxVal := a[i];
    }
    i := i + 1;
  }
  sum := maxVal + minVal;
}