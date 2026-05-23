method ElementWiseMultiply(a: seq<int>, b: seq<int>) returns (result: seq<int>)
    requires a != null && b != null
    requires |a| == |b|
    ensures result != null
    ensures |result| == |a|
    ensures forall i :: 0 <= i < |a| ==> result[i] == a[i] * b[i]
{
    result := [];
    var i := 0;
    while i < |a|
        invariant 0 <= i <= |a|
        invariant |result| == i
        invariant forall k :: 0 <= k < i ==> result[k] == a[k] * b[k]
    {
        result := result + [a[i] * b[i]];
        i := i + 1;
    }
}