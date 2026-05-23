predicate IsOdd(x: int)
{
    x % 2 != 0
}

method FilterOddNumbers(a: array<int>) returns (odds: seq<int>)
    requires a != null
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < a.Length ==> (IsOdd(a[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == a[i])
{
    odds := [];
    var index := 0;
    while index < a.Length
        invariant 0 <= index <= a.Length
        invariant forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
        invariant forall i :: 0 <= i < index ==> (IsOdd(a[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == a[i])
        invariant |odds| == length(odds)
    {
        if IsOdd(a[index])
        {
            odds := odds + [a[index]];
        }
        index := index + 1;
    }
}