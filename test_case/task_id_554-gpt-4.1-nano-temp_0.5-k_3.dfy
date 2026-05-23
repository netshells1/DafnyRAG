predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOdd(lst: seq<int>) returns (odds: seq<int>)
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < |lst| ==> (IsOdd(lst[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == lst[i])
{
    odds := [];
    var index := 0;
    var i := 0;
    while i < |lst|
        invariant 0 <= i <= |lst|
        invariant |odds| == index
        invariant forall k :: 0 <= k < index ==> IsOdd(odds[k])
        invariant forall k :: 0 <= k < i ==> (IsOdd(lst[k]) ==> exists j :: 0 <= j < index && odds[j] == lst[k])
    {
        if IsOdd(lst[i]) {
            odds := odds + [lst[i]];
            index := index + 1;
        }
        i := i + 1;
    }
}