method ElementWiseDivide(a: seq<int>, b: seq<int>) returns (result: seq<int>)
    requires a != null && b != null
    requires a.Length == b.Length
    requires forall i :: 0 <= i < b.Length ==> b[i] != 0
    ensures result != null
    ensures result.Length == a.Length
    ensures forall i :: 0 <= i < result.Length ==> result[i] == a[i] / b[i]
{
    result := [];
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant result.Length == i
        invariant forall k :: 0 <= k < i ==> result[k] == a[k] / b[k]
    {
        result := result + [a[i] / b[i]];
        i := i + 1;
    }
}