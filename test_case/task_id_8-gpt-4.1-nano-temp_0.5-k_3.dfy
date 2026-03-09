method SquareElements(a: array<int>) returns (squared: array<int>)
    requires a != null
    ensures squared.Length == a.Length
    ensures forall i :: 0 <= i < a.Length ==> squared[i] == a[i] * a[i]
{
    squared := new int[a.Length];
    var i := 0;
    while i < a.Length
        invariant 0 <= i <= a.Length
        invariant squared.Length == a.Length
        invariant forall k :: 0 <= k < i ==> squared[k] == a[k] * a[k]
    {
        squared[i] := a[i] * a[i];
        i := i + 1;
    }
}