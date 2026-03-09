method SquareElements(a: array<int>) returns (squares: array<int>)
    requires a != null
    ensures squares.Length == a.Length
    ensures forall i :: 0 <= i < a.Length ==> squares[i] == a[i] * a[i]
{
    var squaresArray := new int[a.Length];
    for i := 0 to a.Length
        invariant 0 <= i <= a.Length
        invariant squaresArray.Length == a.Length
        invariant forall k :: 0 <= k < i ==> squaresArray[k] == a[k] * a[k]
    {
        squaresArray[i] := a[i] * a[i];
    }
    return squaresArray;
}