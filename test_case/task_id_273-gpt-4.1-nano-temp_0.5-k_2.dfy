predicate SeqInRange(s: seq<int>, i: int)
  reads s
{
  0 <= i < |s|
}

method ElementwiseSubtract(a: seq<int>, b: seq<int>) returns (result: seq<int>)
  requires a != null && b != null
  requires |a| == |b|
  ensures result != null
  ensures |result| == |a|
  ensures forall i :: 0 <= i < |a| ==> result[i] == a[i] - b[i]
{
    var res := [];
    var i := 0;
    while i < |a|
      invariant 0 <= i <= |a|
      invariant |res| == i
      invariant forall j :: 0 <= j < i ==> res[j] == a[j] - b[j]
    {
        res := res + [a[i] - b[i]];
        i := i + 1;
    }
    result := res;
}