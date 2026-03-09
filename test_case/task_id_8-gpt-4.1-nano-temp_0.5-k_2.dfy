method SquareElements(a: array<int>) returns (squares: array<int>)
    requires a != null
    ensures squares.Length == a.Length
    ensures forall i :: 0 <= i < a.Length ==> squares[i] == a[i] * a[i]
{
    var n := a.Length;
    squares := new int[n];
    var i := 0;
    while i < n
        invariant 0 <= i <= n
        invariant squares != null
        invariant squares.Length == n
        invariant forall k :: 0 <= k < i ==> squares[k] == a[k] * a[k]
    {
        squares[i] := a[i] * a[i];
        i := i + 1;
    }
}