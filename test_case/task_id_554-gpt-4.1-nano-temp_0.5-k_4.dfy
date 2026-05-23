predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOdd(lst: seq<int>) returns (odds: seq<int>)
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < |lst| ==> (IsOdd(lst[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == lst[i])
    ensures |odds| <= |lst|
{
    odds := [];
    var index := 0;
    while index < |lst|
        invariant 0 <= index <= |lst|
        invariant forall k :: 0 <= k < |odds| ==> IsOdd(odds[k])
        invariant forall k :: 0 <= k < index ==> (IsOdd(lst[k]) ==> exists j :: 0 <= j < |odds| && odds[j] == lst[k])
        decreases |lst| - index
    {
        if IsOdd(lst[index])
        {
            odds := odds + [lst[index]];
        }
        index := index + 1;
    }
}