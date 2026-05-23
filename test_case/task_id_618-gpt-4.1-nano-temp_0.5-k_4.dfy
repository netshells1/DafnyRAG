method ElementWiseDivide(a: seq<int>, b: seq<int>) returns (result: seq<int>)
    requires a != null && b != null
    requires |a| == |b|
    requires forall i :: 0 <= i < |b| ==> b[i] != 0
    ensures result != null
    ensures |result| == |a|
    ensures forall i :: 0 <= i < |result| ==> result[i] == a[i] / b[i]
{
    var res := new int[|a|];
    var i := 0;
    while i < |a|
        invariant 0 <= i <= |a|
        invariant res.Length == |a|
        invariant forall k :: 0 <= k < i ==> res[k] == a[k] / b[k]
    {
        res[i] := a[i] / b[i];
        i := i + 1;
    }
    result := res;
}