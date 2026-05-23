predicate IsOdd(n: int)
{
    n % 2 != 0
}

method FilterOdd(lst: seq<int>) returns (odds: seq<int>)
    ensures forall i :: 0 <= i < |odds| ==> IsOdd(odds[i])
    ensures forall i :: 0 <= i < |odds| ==> exists j :: 0 <= j < |lst| && lst[j] == odds[i]
    ensures |odds| <= |lst|
    ensures forall i :: 0 <= i < |lst| && IsOdd(lst[i]) ==> exists j :: 0 <= j < |odds| && odds[j] == lst[i]
{
    odds := [];
    var idx := 0;
    while idx < |lst|
        invariant 0 <= idx <= |lst|
        invariant forall k :: 0 <= k < |odds| ==> exists j :: 0 <= j < idx && lst[j] == odds[k]
        invariant forall j :: 0 <= j < idx ==> IsOdd(lst[j])
        invariant |odds| <= idx
    {
        if IsOdd(lst[idx]) {
            odds := odds + [lst[idx]];
        }
        idx := idx + 1;
    }
}